"""
Convex Set Analysis: VPolytope and Hpolytope
"""

using Polyhedra
import Combinatorics, LazySets

function print_matrix(mat)
    for i in 1:size(mat, 1)
        println(mat[i,:])
    end
end


function constrs_to_Ab(constrs)
    m = length(constrs)
    Ab = zeros(Float64, (m, length(constrs[1].a)+1))

    for (i,c) in enumerate(constrs) 
        Ab[i,1:end-1] = c.a 
        Ab[i,end] = c.b
    end 

    Ab
end

function V_to_H(extpts)
    extpts = convert(Array{Float64,2}, extpts)
    P = LazySets.VPolytope(extpts)
    println("# of extreme points = ", length(P.vertices))
    println("dimension = ", LazySets.dim(P))

    constrs = LazySets.constraints_list(P)
    Ab = constrs_to_Ab(constrs)
    print_matrix(Ab)
end

function get_extreme_points_of_box(dim)
    vertices = zeros(Int, dim, 2^dim)
    cnt = 1
    for S in Combinatorics.powerset(1:dim)
        for i in S
            vertices[i,cnt] = 1
        end
        cnt += 1 
    end
    vertices
end

function get_extreme_points_of_hypergraph(num_nodes, edges)
    vertices = get_extreme_points_of_box(num_nodes)
    for e in edges
        row = ones(Int, size(vertices, 2))
        for v in e 
            row = row .* vertices[v,:] 
        end
        vertices = vcat(vertices, reshape(row, 1, 2^num_nodes))
    end
    vertices
end


function main()
    num_nodes = 3
    edges = [(1,2),(2,3),(1,2,3)]
    # num_nodes = 4
    # edges = [(1,2),(2,3),(3,4),(1,4)]

    extpts = get_extreme_points_of_hypergraph(num_nodes, edges)
    print_matrix(extpts)
    V_to_H(extpts)
end

main()