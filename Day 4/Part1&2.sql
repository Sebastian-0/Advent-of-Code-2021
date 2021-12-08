CREATE OR REPLACE FUNCTION create_tables()
RETURNS VOID AS $$
BEGIN
    CREATE TABLE bingo_boards (
        id SERIAL PRIMARY KEY,
        elements INTEGER[][]
    );

    CREATE TABLE bingo_instructions (
        ord SERIAL PRIMARY KEY,
        instruction INTEGER
    );

    CREATE TABLE win_order (
        ord SERIAL PRIMARY KEY,
        id INTEGER,
        score INTEGER
    );
END; $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION destroy_tables()
RETURNS VOID AS $$
BEGIN
    DROP TABLE bingo_boards;
    DROP TABLE bingo_instructions;
    DROP TABLE win_order;
END; $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_boards(num INTEGER)
RETURNS VOID AS $$
DECLARE
    board RECORD;
    updated_elements INTEGER[][];
BEGIN
    FOR board IN SELECT id, elements FROM bingo_boards
    LOOP
        updated_elements := array_replace(board.elements, num, -1);
        UPDATE bingo_boards SET elements = updated_elements WHERE id = board.id;
    END LOOP;
END; $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION check_delta(board RECORD, x INTEGER, y INTEGER, dx INTEGER, dy INTEGER)
RETURNS BOOLEAN AS $$
BEGIN
    FOR i IN 1..array_length(board.elements, 1)
    LOOP
        IF board.elements[y][x] != -1 THEN
            RETURN FALSE;
        END IF;
        x := x + dx;
        y := y + dy;
    END LOOP;
    RETURN TRUE;
END; $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION compute_winner_score(winner INTEGER, last_number INTEGER)
RETURNS INTEGER AS $$
DECLARE
    board RECORD;
    score INTEGER = 0;
BEGIN
    SELECT * INTO board FROM bingo_boards WHERE id = winner;
    
    FOR r IN 1..array_length(board.elements, 1)
    LOOP
        FOR c IN 1..array_length(board.elements, 1)
        LOOP
            IF board.elements[r][c] != -1 THEN
                score := score + board.elements[r][c];
            END IF;
        END LOOP;
    END LOOP;
    
    RETURN score * last_number;
END; $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION check_for_winners(last_number INTEGER)
RETURNS INTEGER AS $$
DECLARE
    board RECORD;
    won BOOLEAN;
BEGIN
    FOR board IN SELECT * FROM bingo_boards ORDER BY id
    LOOP
        IF (SELECT EXISTS(SELECT 1 FROM win_order WHERE id = board.id)) THEN
            CONTINUE;
        END IF;

        won = FALSE;
        FOR r IN 1..array_length(board.elements, 1)
        LOOP
            IF (SELECT check_delta(board, 1, r, 1, 0)) THEN
                won = TRUE;
                EXIT;
            END IF;
        END LOOP;
        
        FOR c IN 1..array_length(board.elements, 1)
        LOOP
            IF (SELECT check_delta(board, c, 1, 0, 1)) THEN
                won = TRUE;
                EXIT;
            END IF;
        END LOOP;
        
        IF won THEN
            INSERT INTO win_order (id, score) VALUES(board.id, (SELECT compute_winner_score(board.id, last_number)));
        END IF;
    END LOOP;
    RETURN -1;
END; $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION simulate()
RETURNS VOID AS $$
DECLARE
    instructions INTEGER[];
    num INTEGER;
    board RECORD;
    first_winner RECORD;
    last_winner RECORD;
    winners RECORD;
BEGIN
    FOR num IN SELECT instruction FROM bingo_instructions ORDER BY ord
    LOOP
        RAISE NOTICE 'Instruction %', num;
        PERFORM update_boards(num);
        PERFORM check_for_winners(num);
    END LOOP;
    
    SELECT id, score INTO first_winner FROM win_order ORDER BY ord ASC LIMIT 1;
    SELECT id, score INTO last_winner FROM win_order ORDER BY ord DESC LIMIT 1;
    RAISE NOTICE 'First winning board was % and won with score %', first_winner.id, first_winner.score;
    RAISE NOTICE 'Last winning board was % and won with score %', last_winner.id, last_winner.score;
END; $$ LANGUAGE plpgsql;

-- Actually execute
SELECT create_tables();

\copy bingo_boards (elements) FROM 'boards.in';
\copy bingo_instructions (instruction) FROM 'instructions.in';
SELECT simulate();

SELECT destroy_tables();

-- Run with:
-- docker run --rm -v "$(pwd)":/aoc -w /aoc --name postgres -e POSTGRES_PASSWORD=cake123 postgres
-- docker exec postgres psql -U postgres -f "Part1&2.sql"
