#!/usr/bin/env julia

using DelimitedFiles

sample_path = joinpath(@__DIR__, "sample.txt")
input_path = joinpath(@__DIR__, "input.txt")

sample = readlines(sample_path)
input = readlines(input_path)

function read_calories(calories)
    elves = []

    elf = []
    for (_, c) in enumerate(calories)
        if isempty(c)
            push!(elves, elf)
            elf = []
            continue
        end

        push!(elf, parse(Int64, c))
    end

    if !isempty(elf)
        push!(elves, elf)
    end

    return elves
end

sample_elves = read_calories(sample)

@assert(maximum(map(e -> sum(e), sample_elves)) == 24000)

elves = read_calories(input)

println("part 1 answer = $(maximum(map(e -> sum(e), elves)))")

@assert(sum(view(sort(map(e -> sum(e), sample_elves), rev=true), 1:3)) == 45000)

println("part 2 answer = $(sum(view(sort(map(e -> sum(e), elves), rev=true), 1:3)))")
