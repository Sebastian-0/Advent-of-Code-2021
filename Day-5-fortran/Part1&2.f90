
! Compile and run with:
! docker run --rm -i -v "$(pwd)":/aoc -w /aoc gcc bash -c "gfortran 'Part1&2.f90' && ./a.out"

! Good resources:
! - https://gcc.gnu.org/onlinedocs/gfortran
! - https://fortran-lang.org/learn/quickstart

program hello
    use, intrinsic :: iso_fortran_env, only : iostat_end
    implicit none

    character(100) :: line
    character(4) :: input_discarded
    integer :: iostatus
    
    integer :: matrix_1(1000, 1000) ! For part 1
    integer :: matrix_2(1000, 1000) ! For part 2
    
    integer :: x1, y1, x2, y2    ! Input
    integer :: idx, x, y, dx, dy ! Indexing/temp
    integer :: n_1, n_2          ! Output
    
    matrix_1 = 0
    matrix_2 = 0
        
    do while (.true.)
        read (*,*, iostat=iostatus) x1, y1, input_discarded, x2, y2
        if (iostatus == iostat_end) then
            exit
        end if
        
        x1 = x1 + 1
        x2 = x2 + 1
        y1 = y1 + 1
        y2 = y2 + 1
        
        ! We only care about straight lines in pt 1
        if (x1 == x2) then
            do y = min(y1, y2), max(y1, y2)
                matrix_1(y, x1) = matrix_1(y, x1) + 1
            end do
        else if (y1 == y2) then
            do x = min(x1, x2), max(x1, x2)
                matrix_1(y1, x) = matrix_1(y1, x) + 1
            end do
        else
            ! Handle diagonals for pt. 2, this could easily be extended to handle horiz/vert lines too
            dx = sign(1, x2 - x1)
            dy = sign(1, y2 - y1)
            x = x1
            y = y1
            do idx = 1, abs(x2 - x1) + 1 
                matrix_2(y, x) = matrix_2(y, x) + 1
                x = x + dx
                y = y + dy
            end do
        end if
    end do
    
    matrix_2 = matrix_2 + matrix_1
    
    n_1 = size(pack(matrix_1, matrix_1 > 1))
    n_2 = size(pack(matrix_2, matrix_2 > 1))

    write(*,"(A, I0)") "|-  Points with >=2 overlap: ", n_1
    write(*,"(A, I0)") "|-/ Points with >=2 overlap: ", n_2
end program hello
