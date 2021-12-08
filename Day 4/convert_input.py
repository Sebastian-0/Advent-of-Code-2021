
with open('instructions.in', 'w') as file:
    file.write(input().replace(',', '\n'))

input() # Empty line

with open('boards.in', 'w') as file:
    while True:
        try:
            board = []
            for i in range(5):
                board.append('{' + ', '.join(input().split()) + '}')
            file.write('{' + ', '.join(board) + '}\n')
            input() # Empty line
        except EOFError:
            break

        
    