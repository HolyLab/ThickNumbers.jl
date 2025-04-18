using ThickNumbers
using DifferentiationInterface
using ForwardDiff

using Test

include(joinpath(dirname(@__DIR__), "setpath.jl"))

using IntervalArith

@testset "DifferentiationInterface" begin
    @test isempty(detect_ambiguities(ThickNumbers))
    @test isempty(detect_ambiguities(IntervalArith))

    for backend in (AutoForwardDiff(), )
        a, b = Interval(1, 2), Interval(0, 0.1)
        f1(t) = a + t*b
        f2(x) = a + abs2(x)/2

        df1(t) = derivative(f1, backend, t)
        df2(x) = derivative(f2, backend, x)
        @test df1(0.5) ≐ b
        @test df2(b) ⩪ b
        ddf2(x) = derivative(df2, backend, x)
        @test ddf2(b) ≐ 1

        # abs
        dabs(x) = derivative(abs, backend, x)
        ddabs(x) = derivative(dabs, backend, x)
        dddabs(x) = derivative(ddabs, backend, x)
        @test dabs(Interval(1.0, 2.0)) === Interval(1.0, 1.0)
        @test ddabs(Interval(1.0, 2.0)) === Interval(0.0, 0.0)
        @test dddabs(Interval(1.0, 2.0)) === Interval(0.0, 0.0)
        @test dabs(Interval(-1.0, 2.0)) === Interval(-1.0, 1.0)
        @test ddabs(Interval(-1.0, 2.0)) === Interval(0.0, Inf)
        abs3 = dddabs(Interval(-1.0, 2.0))
        @test abs3 === Interval(-Inf, Inf) || isnan_tn(abs3)
    end
end
