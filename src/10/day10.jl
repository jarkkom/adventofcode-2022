#!/usr/bin/env julia

using DelimitedFiles

sample_path = joinpath(@__DIR__, "sample.txt")
input_path = joinpath(@__DIR__, "input.txt")

sample = readlines(sample_path)
input = readlines(input_path)

function sum_strengths(input)
    strength_sum = 0

    cycle = 1
    x = 1
    for l in input
        if l == "noop"
            if cycle in (20, 60, 100, 140, 180, 220)
                println("cycle = $(cycle) x = $(x) l = $(l) strength = $(x * cycle)")
                strength_sum += x * cycle
            end

            cycle += 1

            continue
        end
        if startswith(l, "addx ")
            param = parse(Int64, split(l)[2])

            if cycle in (20, 60, 100, 140, 180, 220)
                println("cycle = $(cycle) x = $(x) l = $(l) strength = $(x * cycle)")
                strength_sum += x * cycle
            end
            cycle += 1

            if cycle in (20, 60, 100, 140, 180, 220)
                println("cycle = $(cycle) x = $(x) l = $(l) strength = $(x * cycle)")
                strength_sum += x * cycle
            end
            cycle += 1

            x += param
        end
    end

    return strength_sum
end

@assert(sum_strengths(sample) == 13140)
println("part 1 answer = $(sum_strengths(input))")
@assert(length(parse_moves(input)) == 15880)
