#!/usr/bin/env julia

using DelimitedFiles

sample_path = joinpath(@__DIR__, "sample.txt")
input_path = joinpath(@__DIR__, "input.txt")

sample = readlines(sample_path)
input = readlines(input_path)

function parse_moves(lines)
    visited = Set()

    head = (1, 5)
    tail = (1, 5)

    push!(visited, tail)

    for l in lines
        (dir, count) = split(l, " ")
        dpos = (0, 0)
        if dir == "R"
            dpos = (1, 0)
        elseif dir == "U"
            dpos = (0, -1)
        elseif dir == "D"
            dpos = (0, 1)
        elseif dir == "L"
            dpos = (-1, 0)
        end 

        c = parse(Int64, count)
        for _ in 1:c
            # println("$(dir) $(n)")
            # println("head = $(head) tail = $(tail)")

            # for y in 1:5
            #     for x in 1:5
            #         if head == (x, y)
            #             print("H")
            #         elseif tail == (x, y)
            #             print("T")
            #         elseif in((x, y), visited)
            #             print("#")
            #         else
            #             print(".")
            #         end
            #     end
            #     println()
            # end

            head = (head[1] + dpos[1], head[2] + dpos[2])
            dx = abs(head[1] - tail[1])
            dy = abs(head[2] - tail[2])

            if (dx == 0 || dy == 0) && (dx > 1 || dy > 1)
                tail = (tail[1] + dpos[1], tail[2] + dpos[2])
                push!(visited, tail)
                continue
            end

            if (dx + dy) < 2 || (dx == dy)
                push!(visited, tail)
                continue
            end

            if (dx > 1 && dy == 1) || (dy > 1 && dx == 1)
                if tail[1] < head[1]; tail = (tail[1] + 1, tail[2]); end
                if tail[1] > head[1]; tail = (tail[1] - 1, tail[2]); end

                if tail[2] < head[2]; tail = (tail[1], tail[2] + 1); end
                if tail[2] > head[2]; tail = (tail[1], tail[2] - 1); end

                push!(visited, tail)
                continue
            end

            println("oops! dx = $(dx) dy = $(dy)")
            return visited
        end
    end

    return visited
end

@assert(length(parse_moves(sample)) == 13)
println("part 1 answer = $(length(parse_moves(input)))")
@assert(length(parse_moves(input)) == 6030)
