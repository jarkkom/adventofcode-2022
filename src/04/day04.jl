#!/usr/bin/env julia

using DelimitedFiles

sample_path = joinpath(@__DIR__, "sample.txt")
input_path = joinpath(@__DIR__, "input.txt")

sample = readlines(sample_path)
input = readlines(input_path)

function parse_pairs(pairs)
    r = []
    for p in pairs
        (p1, p2) = split(p, ',')
        (s1, e1) = map(s -> parse(Int64, s), split(p1, '-'))
        (s2, e2) = map(s -> parse(Int64, s), split(p2, '-'))
        push!(r, (range(s1, e1), range(s2, e2)))
    end
    return r
end

function contains(p)
    return issubset(p[1], p[2]) || issubset(p[2], p[1])
end

function intersects(p)
    return length(intersect(p[1], p[2])) > 0
end


@assert(count(p -> contains(p), parse_pairs(sample)) == 2)
println("part 1 answer = $(count(p -> contains(p), parse_pairs(input)))")
@assert(count(p -> contains(p), parse_pairs(input)) == 534)

@assert(count(p -> intersects(p), parse_pairs(sample)) == 4)
println("part 2 answer = $(count(p -> intersects(p), parse_pairs(input)))")
@assert(count(p -> intersects(p), parse_pairs(input)) == 841)
