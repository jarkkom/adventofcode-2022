#!/usr/bin/env julia

using DelimitedFiles

sample_path = joinpath(@__DIR__, "sample.txt")
input_path = joinpath(@__DIR__, "input.txt")

sample = readlines(sample_path)
input = readlines(input_path)

function parse_input(input)
    grid = Set()

    for l in input
        points = split(l, " -> ")

        for pi in 1:length(points)-1
            sp = points[pi]
            ep = points[pi + 1]

            (sx, sy) = split(sp, ',')
            (ex, ey) = split(ep, ',')

            if sx == ex
                x = parse(Int64, sx)
                miny = min(parse(Int64, sy), parse(Int64, ey))
                maxy = max(parse(Int64, sy), parse(Int64, ey))
                for y in miny:maxy
                    push!(grid, (x, y))
                end
            end

            if sy == ey
                y = parse(Int64, sy)
                minx = min(parse(Int64, sx), parse(Int64, ex))
                maxx = max(parse(Int64, sx), parse(Int64, ex))
                for x in minx:maxx
                    push!(grid, (x, y))
                end
            end
        end
    end

    return grid
end

function pour_sand(input)
    grains = 0

    max_y = 0
    for p in input
        max_y = max(max_y, p[2])
    end

    grain_x = 500
    grain_y = 0
    while true
        if grain_y > max_y
            # falling to infinity
            return grains
        end

        if !in((grain_x, grain_y + 1), input)
            # we can move down
            grain_y += 1
            continue
        elseif !in((grain_x - 1, grain_y + 1), input)
            # we can move down and left
            grain_x -= 1
            grain_y += 1
            continue
        elseif !in((grain_x + 1, grain_y + 1), input)
            # we can move down and right
            grain_x += 1
            grain_y += 1
            continue
        else
            # can't move, grain stops here
            push!(input, (grain_x, grain_y))
            grains += 1
            grain_x = 500
            grain_y = 0
        end

    end
    return grains
end

function pour_sand_until_blocked(input)
    grains = 1

    max_y = 0
    for p in input
        max_y = max(max_y, p[2])
    end

    grain_x = 500
    grain_y = 0
    while true
        if !in((grain_x, grain_y + 1), input) && grain_y < max_y + 1
            # we can move down
            grain_y += 1
            continue
        elseif !in((grain_x - 1, grain_y + 1), input) && grain_y < max_y + 1
            # we can move down and left
            grain_x -= 1
            grain_y += 1
            continue
        elseif !in((grain_x + 1, grain_y + 1), input) && grain_y < max_y + 1
            # we can move down and right
            grain_x += 1
            grain_y += 1
            continue
        else
            # we're blocked, exit
            if grain_y == 0
                println("bloked at $(grains)")
                break
            end

            # can't move, grain stops here
            push!(input, (grain_x, grain_y))
            grains += 1
            grain_x = 500
            grain_y = 0
        end
    end
    return grains
end

@assert(pour_sand(parse_input(sample)) == 24)
println("answer for part 1 = $(pour_sand(parse_input(input)))")
@assert(pour_sand(parse_input(input)) == 892)

@assert(pour_sand_until_blocked(parse_input(sample)) == 93)
println("answer for part 2 = $(pour_sand_until_blocked(parse_input(input)))")
