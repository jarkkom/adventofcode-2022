#!/usr/bin/env julia

using DelimitedFiles

sample_path = joinpath(@__DIR__, "sample.txt")
input_path = joinpath(@__DIR__, "input.txt")

sample = readlines(sample_path)
input = readlines(input_path)

struct File
    name::String
    size::Int64
end

struct Dir
    name::String
    children::Vector{Union{File, Dir}}
    parent::Union{Missing, Dir}
end

function readtree(input)
    root = Dir("/", [], Missing())

    cwd = root

    i = 1
    while i <= length(input)
        l = input[i]
        i += 1

        if l == "\$ cd /"
            cwd = root
            continue
        end

        if l == "\$ cd .."
            cwd = cwd.parent
            continue
        end

        if l == "\$ ls"
            while i <= length(input)
                ll = input[i]
                if startswith(ll, "\$ ")
                    break
                else
                    i += 1
                    (s, n) = split(ll, " ")
                    if s == "dir"
                        push!(cwd.children, Dir(n, [], cwd))
                    else
                        push!(cwd.children, File(n, parse(Int64, s)))
                    end
                end
            end
            continue
        end

        if startswith(l,"\$ cd")
            (_, _, dir) = split(l, " ")
            cwd = cwd.children[findfirst(x -> x.name == dir, cwd.children)]
            continue
        end

        println("UNKNOWN $(l)")
        break
    end
    return root
end

function sum_tree(dir, sums, limit)
    total = 0
    for c in dir.children
        if typeof(c) == File
            total += c.size
        end
        if typeof(c) == Dir
            total += sum_tree(c, sums, limit)
        end
    end

    if total <= limit
        push!(sums, total)
        return total
    end
    return total
end

st = readtree(sample)
stotals = []
sum_tree(st, stotals, 100000)
@assert(sum(stotals) == 95437)

it = readtree(input)
itotals = []
sum_tree(it, itotals, 100000)

println("part 1 answer = $(sum(itotals))")
@assert(sum(itotals) == 1644735)

stotals = []
sum_tree(st, stotals, 70000000)
s_unused = 70000000 - stotals[end]
s_required = 30000000 - s_unused
@assert(stotals[end] == 48381165)
@assert(s_unused == 21618835)
@assert(s_required == 8381165)
stotals = sort(stotals)
@assert(stotals[findfirst(x -> x >= s_required, stotals)] == 24933642)

itotals = []
sum_tree(it, itotals, 70000000)
i_unused = 70000000 - itotals[end]
i_required = 30000000 - i_unused
itotals = sort(itotals)
println("part 2 answer = $(itotals[findfirst(x -> x > i_required, itotals)])")
@assert(itotals[findfirst(x -> x > i_required, itotals)] == 1300850)