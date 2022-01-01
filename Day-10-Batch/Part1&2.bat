:: Run with:
:: Part1&2.bat

:: Good resources:
:: - https://www.tutorialspoint.com/batch_script/batch_script_operators.htm

@echo off
setlocal enabledelayedexpansion

set opening_stack=
set syntax_score=0
set autocomplete_scores=
set autocomplete_size=0

set lines=
set line_idx=0

if "%1" neq "" (
    goto read_file
)

:: Read input from the console, does not work when piped from a file
:read_input
set line=
set /p line=
if not defined line (
    goto process_lines
)
set "lines[!line_idx!]=%line%"
set /a line_idx+=1
goto read_input

:: Read input from the target file
:read_file
for /f "tokens=*" %%i in (%1) do (
    set "lines[!line_idx!]=%%i"
    set /a line_idx+=1
)

:process_lines
set lines_size=%line_idx%
set line_idx=0

:process_line_loop
if %line_idx% equ %lines_size% (
    goto sort_autocomplete
)
set "line=!lines[%line_idx%]!"
set /a line_idx+=1
echo Processing: !line!

set corrupted=false
set n=-1
set idx=0

:: Check for corruption, if none is found proceed to autocomplete
:syntax_loop
set char=!line:~%idx%,1!
if not defined char (
    goto autocomplete
)

set required=
set points=
if "%char%" equ "}" (
    set "required={"
    set points=1197
)
if "%char%" equ ">" (
    set "required=<"
    set points=25137
)
if "%char%" equ ")" (
    set "required=("
    set points=3
)
if "%char%" equ "]" (
    set "required=["
    set points=57
)

if not defined required (
    :: Opening character
    set /a n+=1
    set "opening_stack[!n!]=%char%"
) else (
    :: Closing character
    if "!opening_stack[%n%]!" neq "%required%" (
        set corrupted=true
        set /a syntax_score+=%points%
        goto autocomplete
    )
    set /a n-=1
)

set /a idx+=1
goto syntax_loop

:: For non-corrupt lines compute the autocomplete score
:autocomplete
set score=0
if %corrupted% equ true (
    goto process_line_loop
)

:autocomplete_loop
if %n% lss 0 (
    echo Autocomplete score: %score%
    set /a autocomplete_scores[%autocomplete_size%]=%score%
    set /a autocomplete_size+=1
    goto process_line_loop
)
set points=
set char=!opening_stack[%n%]!
if "%char%" equ "{" (
    set points=3
)
if "%char%" equ "<" (
    set points=4
)
if "%char%" equ "(" (
    set points=1
)
if "%char%" equ "[" (
    set points=2
)

:: Ensure we get no overflow by setting max value as int max (429496729 ~= (2^31-1)/5)
if %score% gtr 429496729 (
    set /a score=2147483647
) else (
    set /a score=%score%*5 + %points%
)

set /a n-=1
goto autocomplete_loop

:: Sort the autocomplete scores.
::
:: This is done by creating a new array with the scores as the indices. This works
:: because batch will make sure array indices are in ascending order. There is no
:: other way to properly sort the values (e.g. the sort command requires a file).
::
:: Unfortunately batch sorts the array indices using ASCII sorting instead of
:: numerical sorting so to get the proper order we need to 0-pad all the values as
:: well.
::
:: Another problem is that duplicated values will be merged which would break our
:: algorithm since we want the median. To fix that issue we add a suffix like '_num'
:: to the end with a unique identifier for each score.

:sort_autocomplete

:: Start the score ID at 10 to avoid problems with ASCII comparison (e.g. 1 vs. 10),
:: we know input is <90 lines long.
set score_id=10
set /a max=%autocomplete_size%-1
for /l %%a in (0,1,%max%) do (
    set num=!autocomplete_scores[%%a]!
    set index=0000000000000!num!_!score_id!
    set tmp[!index:~-16!]=!num!
    set /a score_id+=1
)

:: Find the median
set idx=0
set median=
set /a mid_idx=autocomplete_size/2
for /F "tokens=2 delims==" %%a in ('set tmp[') do (
    if !idx! equ %mid_idx% (
        set median=%%a
    )
    set /a idx+=1
)

echo.
echo Syntax score: %syntax_score%
echo Autocomplete median score: %median%

exit /b
