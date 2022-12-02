#!/usr/bin/env julia

using DelimitedFiles

sample_path = joinpath(@__DIR__, "sample.txt")
input_path = joinpath(@__DIR__, "input.txt")

sample = readlines(sample_path)
input = readlines(input_path)

function read_games(games)
    rounds = []

    round = []
    for (_, l) in enumerate(games)
        round = split(l, " ")

        push!(rounds, round)
    end

    return rounds
end

function score_rounds(rounds)
    total = 0

    for (_, round) in enumerate(rounds)
        opponent = round[1][1] - 'A' 
        you = round[2][1] - 'X'
        total += you + 1

        # draw?
        if opponent == you
            total += 3
        end

        # win?
        if you == (opponent + 1) % 3
            total += 6
        end
    end

    return total
end

function score_rounds_2(rounds)
    total = 0
   
    for (_, round) in enumerate(rounds)
        opp = round[1][1]
        outcome = round[2][1]

        total += (outcome - 'X') * 3 + ((opp - 'A' + outcome - 'X' + 2) % 3 + 1)
    end

    return total
end

sample_rounds = read_games(sample)
input_rounds = read_games(input)

@assert(score_rounds(sample_rounds) == 15)
println("part 1 answer = $(score_rounds(input_rounds))")
@assert(score_rounds(input_rounds) == 10994)

@assert(score_rounds_2(sample_rounds) == 12)
println("part 2 answer = $(score_rounds_2(input_rounds))")
@assert(score_rounds_2(input_rounds) == 12526)
