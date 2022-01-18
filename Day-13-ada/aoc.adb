-- Run with:
-- docker build -t ada .
-- docker run --rm -i -v "$(pwd)":/aoc -w /aoc ada bash -c "gnatmake aoc.adb && ./aoc"

-- Good resources:
-- - https://learn.adacore.com/courses/intro-to-ada/
-- - Closest to API ref: https://www.adaic.org/resources/add_content/standards/05rm/html/RM-0-5.html
-- - All attributes: https://en.wikibooks.org/wiki/Ada_Programming/Attributes

with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Containers.Vectors;
with Ada.Containers.Ordered_Sets;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.IO_Exceptions;

procedure AoC is
    type Pos is record
        X : Integer;
        Y : Integer;
    end record;

    function "<" (Left, Right : Pos) return Boolean is
    begin
        return Left.X < Right.X or (Left.X = Right.X and Left.Y < Right.Y);
    end "<";

    package Pos_Vectors is new Ada.Containers.Vectors(
        Index_Type => Natural,
        Element_Type => Pos);

    package Pos_Vectors_Sorting is new Pos_Vectors.Generic_Sorting;

    
    Current : Pos;
    Points : Pos_Vectors.Vector;

    First_Fold_Unique : Integer := -1;
    Result : Unbounded_String;

    
    procedure Parse_Coords(Line : String) is
        Idx : Integer;
        X : Integer;
        Y : Integer;
    begin
        Idx := Index(Line, ",", 1);
        X := Integer'Value(Line(Line'First .. Idx-1));
        Y := Integer'Value(Line(Idx+1 .. Line'Last));
        Points.Append((X, Y));
        Current := (X, Y);
    end Parse_Coords;
    
    procedure Parse_Fold(Line : String) is
        Idx : Integer;
        Axis : Character;
        Pos : Integer;
    begin
        Idx := Index(Line, "=", 1);
        Axis := Line(Idx-1);
        Pos := Integer'Value(Line(Idx+1 .. Line'Last));
        for P of Points loop
            if Axis = 'x' and P.X > Pos then
                P.X := P.X - (P.X - Pos)*2;
            elsif Axis = 'y' and P.Y > Pos then
                P.Y := P.Y - (P.Y - Pos)*2;
            end if;
        end loop;
    end Parse_Fold;
begin
    loop
        begin
            declare
                package Pos_Sets is new Ada.Containers.Ordered_Sets(
                    Element_Type => Pos);
                
                Line : String := Get_Line;
                Unique_Positions : Pos_Sets.Set;
            begin
                if Line'Length /= 0 then
                    if Line(Line'First) = 'f' then
                        Parse_Fold(Line);

                        if First_Fold_Unique < 0 then
                            for P of Points loop
                                Unique_Positions.Include(P);
                            end loop;
                            First_Fold_Unique := Integer(Unique_Positions.Length);
                        end if;
                    else
                        Parse_Coords(Line);
                    end if;
                end if;
            end;
        exception
            when E : Ada.IO_Exceptions.End_Error =>
                exit;
        end;
    end loop;

    Put_Line("");
    Put_Line("Unique points after 1 step: " & First_Fold_Unique'Image);
    Put_Line("Final image:");
    for Y in 0..10 loop
        Result := To_Unbounded_String("");
        for X in 0..40 loop
            if Points.Contains((X, Y)) then
                Append(Result, "#");
            else
                Append(Result, " ");
            end if;
        end loop;
        Put_Line(To_String(Result));
    end loop;
end AoC;