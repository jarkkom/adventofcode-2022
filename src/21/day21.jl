#!/usr/bin/env julia

using DelimitedFiles

sample_path = joinpath(@__DIR__, "sample.txt")
input_path = joinpath(@__DIR__, "input.txt")

sample = readlines(sample_path)
input = readlines(input_path)

struct Node
    arg_a::Union{Int64, String}
    oper::String
    arg_b::Union{Int64, String}
    value::Union{Nothing, Int64}
end

function parse_tree(lines)
    tree = Dict()

    for l in lines
        m = match(r"(\S+): (\S+) (\S+) (\S+)", l)
        if m !== nothing
            arg_a = tryparse(Int64, m.captures[2])
            if arg_a === nothing arg_a = String(m.captures[2]) end 
            arg_b = tryparse(Int64, m.captures[4])
            if arg_b === nothing arg_b = String(m.captures[4]) end 
            tree[m.captures[1]] = Node(arg_a, m.captures[3], arg_b, nothing)
        end

        m = match(r"(\S+): (\d+)", l)
        if m !== nothing
            tree[m.captures[1]] = Node("", "", "", parse(Int64, m.captures[2]))
        end
    end
    #println(tree)
    return tree
end

function solve_tree(tree, node)::Int64
    if tree[node].value !== nothing
        return tree[node].value
    end

    arg_a = tree[node].arg_a
    if typeof(arg_a) == String
        arg_a = solve_tree(tree, arg_a)
    end

    arg_b = tree[node].arg_b
    if typeof(arg_b) == String
        arg_b = solve_tree(tree, arg_b)
    end

    if tree[node].oper == "+"
        return arg_a + arg_b
    end
    if tree[node].oper == "-"
        return arg_a - arg_b
    end
    if tree[node].oper == "*"
        return arg_a * arg_b
    end
    if tree[node].oper == "/"
        return arg_a / arg_b
    end
end

@assert(solve_tree(parse_tree(sample), "root") == 152)
println("part 1 answer = $(solve_tree(parse_tree(input), "root"))")
@assert(solve_tree(parse_tree(input), "root") == 291425799367130)

