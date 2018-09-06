! This code generates a strutured triangular grid in a rectangular
! domain of size Lx*Ly and writes in a .msh format. This grid looks
! like English flag. 
!
! I wrote this code as I thought it was not possible to generate
! in gmsh. But gmsh community helped me to create the mesh in 
! the gmsh itself.
!
! To use this code, following things should be specified.
! Lx : Length of domain in x-dir
! Ly : Length of domain in y-dir
! nx : no of points in x-dir
! ny : no of points in y-dir
! left, right, bottom, top : integer tags for boundaries of the domain
! Also user needs to specify filename of his/her interest where code
! writes the grid file.

program english_flag_mesh
implicit none
integer :: i, j, k, nx, ny, nv, nc, ne, icount
integer :: left, right, bottom, top
double precision :: Lx, Ly, dx, dy
double precision, allocatable :: x(:), y(:), coord(:,:)
integer, allocatable :: tria(:,:), edge(:,:), tag(:)

nx = 13
ny = 5

Lx = 1.3d0
Ly = 0.5d0

left = 1
right = 2
bottom = 3
top = 4

allocate(x(1:nx), y(1:ny))

dx = Lx/(nx-1)
dy = Ly/(ny-1)

x(1) = 0.0d0
do i = 2, nx
   x(i) = x(i-1) + dx
enddo

y(1) = 0.0d0
do i = 2, ny
   y(i) = y(i-1) + dy
enddo

nv = nx*ny
allocate(coord(1:2,1:nv))
do j = 1, ny
   do i = 1, nx
      k = i + (j-1)*nx
      coord(1, k) = x(i)
      coord(2, k) = y(j)
   enddo
enddo

!create boundary edges
ne = 2*(nx-1) + 2*(ny-1)
allocate(edge(1:2, 1:ne), tag(1:ne))
icount = 0
! bottom
do i = 1, nx-1
   icount = icount+1
   edge(1, icount) = i
   edge(2, icount) = i+1
   tag(icount) = bottom
enddo
! top
do i = 1, nx-1
   icount = icount+1
   edge(1, icount) = i + nx*(ny-1)
   edge(2, icount) = edge(1, icount) + 1
   tag(icount) = top
enddo
! right
do i = 1, ny-1
   icount = icount+1
   edge(1, icount) = nx*i
   edge(2, icount) = nx*(i+1)
   tag(icount) = right
enddo
! left
do i = 1, ny-1
   icount = icount+1
   edge(1, icount) = 1 + nx*(i-1)
   edge(2, icount) = 1 + nx*i
   tag(icount) = left
enddo

if(ne .ne. icount)then
   print*, 'Error in edges'
   call abort
endif

!create triangles
nc = 2*(nx-1)*(ny-1)
allocate(tria(1:3, 1:nc))
icount = 0
do j = 1, ny-1
do i = 1, nx-1
   ! split in right direction
   if((mod(i,2)==1 .and. mod(j,2)==1) .or. (mod(i,2)==0 .and. mod(j,2)==0))then
      icount = icount+1
      tria(1, icount) = i + (j-1)*nx
      tria(2, icount) = i + (j-1)*nx + nx + 1
      tria(3, icount) = i + (j-1)*nx + nx

      icount = icount+1
      tria(1, icount) = i + (j-1)*nx
      tria(2, icount) = i + (j-1)*nx + 1
      tria(3, icount) = i + (j-1)*nx + nx + 1
   ! split in left direction   
   else
      icount = icount+1
      tria(1, icount) = i + (j-1)*nx
      tria(2, icount) = i + (j-1)*nx + 1
      tria(3, icount) = i + (j-1)*nx + nx

      icount = icount+1
      tria(1, icount) = i + (j-1)*nx + 1
      tria(2, icount) = i + (j-1)*nx + nx + 1
      tria(3, icount) = i + (j-1)*nx + nx
   endif

enddo
enddo

if(nc .ne. icount)then
   print*, 'Error in cells'
   call abort
endif

print*, "!------------------------------------------"
print*, "Writing 2D gmsh grid file"

open(10,file='triangular.msh')

write(10,'(A11)')"$MeshFormat"
write(10,'(A8)')"2.2 0 8"
write(10,'(A14)')"$EndMeshFormat"

write(10,'(A6)')"$Nodes"
write(10, '(I8)') nv        ! no of vertices
do i = 1, nv
    write(10,'(I8,1X,3F20.14)') i, coord(1:2,i), 0.0d0  ! coordinates of each vertex
enddo
write(10,'(A9)')"$EndNodes"

write(10,'(A9)')"$Elements"
write(10, *) ne+nc      ! no of elements (edges + cells)
do i=1, ne
   write(10,*) i, 1, 2, tag(i), tag(i), edge(1:2, i)
enddo
do i=1, nc
   write(10,*) ne+i, 2, 2, 1, 1, tria(1:3, i)
enddo
write(10,'(A12)')"$EndElements"

close(10)

print*, "Finished writing gmsh grid file"
print*, "!------------------------------------------"

end program
