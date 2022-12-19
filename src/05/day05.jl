#!/usr/bin/env julia

using DelimitedFiles

sample_path = joinpath(@__DIR__, "sample.txt")
input_path = joinpath(@__DIR__, "input.txt")

sample = readlines(sample_path)
input = readlines(input_path)

function read_stacks_moves(lines)
    stacks = Dict()

    ls = collect(lines)

    while !isempty(ls)
        l = popfirst!(ls)
        if isempty(l)
            break
        end

        stack = 1
        col = 2
        while col < length(l)
            if 'A' <= l[col] <= 'Z'
                get!(stacks, stack, [])
                push!(stacks[stack], l[col])
            end

            col += 4
            stack += 1
        end 
    end

    return stacks, ls
end

function parse_moves(stacks, moves)
    for (_, move) in enumerate(moves)
        m = match(r"move (\d+) from (\d+) to (\d+)", move)
        for i in 1:parse(Int64, m.captures[1])
            from = parse(Int64, m.captures[2])
            to = parse(Int64, m.captures[3])
            pushfirst!(stacks[to], popfirst!(stacks[from]))
        end
    end

    r = [] 
    for (_, i) in enumerate(sort!(collect(keys(stacks))))
        push!(r, stacks[i][1])
    end
    return join(r)
end

function parse_moves_2(stacks, moves)
    for (_, move) in enumerate(moves)
        m = match(r"move (\d+) from (\d+) to (\d+)", move)
        n = parse(Int64, m.captures[1])
        from = parse(Int64, m.captures[2])
        to = parse(Int64, m.captures[3])

        pushfirst!(stacks[to], stacks[from][1:n]...)
        stacks[from] = stacks[from][n+1:end]
    end

    r = [] 
    for (_, i) in enumerate(sort!(collect(keys(stacks))))
        push!(r, stacks[i][1])
    end
    return join(r)
end


@assert(parse_moves(read_stacks_moves(sample)...) === "CMZ")
println("part 1 answer = $(parse_moves(read_stacks_moves(input)...))")
@assert(parse_moves(read_stacks_moves(input)...) === "ZRLJGSCTR")

@assert(parse_moves_2(read_stacks_moves(sample)...) === "MCD")
println("part 2 answer = $(parse_moves_2(read_stacks_moves(input)...))")
@assert(parse_moves_2(read_stacks_moves(input)...) === "PRTTGRFPB")
