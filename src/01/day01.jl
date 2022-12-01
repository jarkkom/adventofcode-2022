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
input_elves = read_calories(input)

max_calories(elves) = maximum(sum.(elves))
@assert(max_calories(sample_elves) == 24000)
println("part 1 answer = $(max_calories(input_elves))")

topk_sum_calories(elves) = sum(sort(sum.(elves), rev=true)[1:3])
@assert(topk_sum_calories(sample_elves) == 45000)
println("part 2 answer = $(topk_sum_calories(input_elves))")
