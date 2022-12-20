#!/usr/bin/env julia

using DelimitedFiles

sample_path = joinpath(@__DIR__, "sample.txt")
input_path = joinpath(@__DIR__, "input.txt")

sample = readlines(sample_path)
input = readlines(input_path)

function read_heights(lines)
    heights = []

    for l in lines
        for h in l
            push!(heights, parse(Int64, h))
        end
    end

    return reshape(heights, :, length(lines))
end

function find_visible(heights)
    visible = Set()

    for i in axes(heights, 1)
        max_h = -1
        for j in axes(heights, 2)
            ix = CartesianIndex(i, j)
            if heights[ix] > max_h
                max_h = heights[ix]
                push!(visible, ix)
            end
        end

        max_h = -1
        for j in reverse(axes(heights, 2))
            ix = CartesianIndex(i, j)
            if heights[ix] > max_h
                max_h = heights[ix]
                push!(visible, ix)
            end
        end
    end

    for j in axes(heights, 2)
        max_h = -1
        for i in axes(heights, 1)
            ix = CartesianIndex(i, j)
            if heights[ix] > max_h
                max_h = heights[ix]
                push!(visible, ix)
            end
        end

        max_h = -1
        for i in reverse(axes(heights, 1))
            ix = CartesianIndex(i, j)
            if heights[ix] > max_h
                max_h = heights[ix]
                push!(visible, ix)
            end
        end
    end
    return visible
end

function find_high(heights)
    highest_score = 0

    for i in 2:size(heights, 1)-1
        for j in 2:size(heights, 2)-1
            ix = CartesianIndex(i, j)
            h = heights[ix]

            u = d = l = r = 0
            # up
            for n in reverse(1:j-1)
                u = j - n
                if heights[CartesianIndex(i, n)] >= h
                    break
                end
            end
            # down
            for n in j + 1:size(heights, 2)
                d = n - j
                if heights[CartesianIndex(i, n)] >= h
                    break
                end
            end
            # left
            for n in reverse(1:i-1)
                l = i - n
                if heights[CartesianIndex(n, j)] >= h
                    break
                end
            end
            # right
            for n in i + 1:size(heights, 1)
                r = n - i
                if heights[CartesianIndex(n, j)] >= h
                    break
                end
            end

            if u * d * l * r > highest_score
                highest_score = u * d * l * r
            end
        end
    end

    return highest_score
end


@assert(length(find_visible(read_heights(sample))) == 21)
println("part 1 answer = $(length(find_visible(read_heights(input))))")
@assert(length(find_visible(read_heights(input))) == 1690)

@assert(find_high(read_heights(sample)) == 8)
println("part 2 answer = $(find_high(read_heights(input)))")
@assert(find_high(read_heights(input)) == 535680)
