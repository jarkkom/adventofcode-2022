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

    move_map = Dict(
        "A" => 0,
        "X" => 0,
        "B" => 1,
        "Y" => 1,
        "C" => 2,
        "Z" => 2)

    for (_, round) in enumerate(rounds)
        opponent = move_map[round[1]]
        you = move_map[round[2]]
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

    outcomes = Dict(
        "X" => Dict(
            "A" => 0 + 3,
            "B" => 0 + 1,
            "C" => 0 + 2,
        ),
        "Y" => Dict(
            "A" => 3 + 1,
            "B" => 3 + 2,
            "C" => 3 + 3,
        ),
        "Z" => Dict(
            "A" => 6 + 2,
            "B" => 6 + 3,
            "C" => 6 + 1,
        ),
    )
    
    for (_, round) in enumerate(rounds)
        opp = round[1]
        outcome = round[2]

        total += outcomes[outcome][opp]
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
