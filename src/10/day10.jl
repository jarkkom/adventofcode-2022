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

function draw_pixel(x, cycle)
    beam_pos = cycle % 40

    if beam_pos >= x - 1 && beam_pos < x + 2
        print("#")
    else
        print(".")
    end

    if beam_pos == 39
        println()
    end
end

function draw_sprite(input)
    cycle = 0
    x = 1
    for l in input
        if l == "noop"
            draw_pixel(x, cycle)
            cycle += 1
            continue
        end
        if startswith(l, "addx ")
            param = parse(Int64, split(l)[2])

            draw_pixel(x, cycle)
            cycle += 1

            draw_pixel(x, cycle)
            cycle += 1

            x += param
        end
    end

    while cycle < 240
        draw_pixel(x, cycle)
        cycle += 1
    end
end


@assert(sum_strengths(sample) == 13140)
println("part 1 answer = $(sum_strengths(input))")
@assert(sum_strengths(input) == 15880)

draw_sprite(sample)
println()
draw_sprite(input)