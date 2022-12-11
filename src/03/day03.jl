#!/usr/bin/env julia

using DelimitedFiles

sample_path = joinpath(@__DIR__, "sample.txt")
input_path = joinpath(@__DIR__, "input.txt")

sample = readlines(sample_path)
input = readlines(input_path)

function find_common(rucksacks)
    r = 0
    for rucksack in rucksacks
        h1 = rucksack[1:div(length(rucksack), 2)]
        h2 = rucksack[div(length(rucksack), 2)+1:length(rucksack)]

        i = intersect(h1, h2)[1]
        if 'a' <= i <= 'z' 
            r += i - 'a' + 1
        end
        if 'A' <= i <= 'Z' 
            r += i - 'A' + 27
        end
    end
    return r
end

function find_common_groups(rucksacks)
    r = 0
    for rs in Iterators.partition(rucksacks, 3)
        i = intersect(rs...)[1]
        if 'a' <= i <= 'z' 
            r += i - 'a' + 1
        end
        if 'A' <= i <= 'Z' 
            r += i - 'A' + 27
        end
    end
    return r
end


@assert(find_common(sample) == 157)
println("part 1 answer = $(find_common(input))")
@assert(find_common(input) == 7793)

@assert(find_common_groups(sample) == 70)
println("part 2 answer = $(find_common_groups(input))")
@assert(find_common_groups(input) == 2499)
