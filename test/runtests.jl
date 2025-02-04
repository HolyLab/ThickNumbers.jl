using ThickNumbers
using Test

include("setpath.jl")

using IntervalArith

@testset "ThickNumbers generics" begin
    # Test all the operations defined in ThickNumbers
    x, y = Interval(1.0, 3.0), Interval(-1.0, 3.0)
    @test valuetype(x) === valuetype(typeof(x)) === Float64
    @test loval(x) === 1.0
    @test hival(x) === 3.0
    @test mid(x) === 2.0
    @test wid(x) === 2.0
    @test rad(x) === 1.0
    @test typemin(x) ≐ Interval(-Inf, -Inf)
    @test typemax(x) ≐ Interval(Inf, Inf)
    @test mig(x) === 1.0
    @test mig(y) === 0.0
    @test mag(x) === 3.0
    @test mag(y) === 3.0
    @test mag(Interval(-5, 1)) === 5
    @test lohi(Interval{Float64}, 1, 3) === x
    @test midrad(Interval{Float64}, 2, 1) === x
    @test basetype(Interval{Float64}) === Interval

    @test isequal_tn(Interval(1, 2), Interval(1, 2))
    @test_throws FPTNException isequal(Interval(1, 2), Interval(1, 2))
    @test !isequal_tn(Interval(1, 2), Interval(1, 3))
    @test Interval(1, 2) ≐ Interval(1, 2)
    @test_throws FPTNException Interval(1, 2) == Interval(1, 2)
    exc = try
        Interval(1, 2) == Interval(1, 3)
        nothing
    catch e
        e
    end
    str = sprint(Base.showerror, exc)
    @test occursin("== is deliberately not implemented", str)
    @test occursin("≐", str)
    @test occursin("doteq", str)
    @test isapprox_tn(Interval(1, 2), Interval(1, nextfloat(2.0)))
    @test Interval(1, 2) ⩪ Interval(1, nextfloat(2.0))
    @test_throws FPTNException Interval(1, 2) ≈ Interval(1, nextfloat(2.0))
    @test !isapprox_tn(Interval(1, 2), Interval(1, 2.1))
    @test isless_tn(Interval(1, 2), Interval(nextfloat(2.0), 3))
    @test isless_tn(Interval(1, 2), nextfloat(2.0))
    @test isless_tn(0, Interval(1, 2))
    @test_throws FPTNException isless(Interval(1, 2), Interval(nextfloat(2.0), 3))
    @test_throws FPTNException isless(Interval(1, 2), nextfloat(2.0))
    @test_throws FPTNException isless(1, Interval(1, 2))
    @test Interval(1, 2) ≺ Interval(nextfloat(2.0), 3)
    @test_throws FPTNException Interval(1, 2) < Interval(nextfloat(2.0), 3)
    @test Interval(nextfloat(2.0), 3) ≻ Interval(1, 2)
    @test_throws FPTNException Interval(nextfloat(2.0), 3) > Interval(1, 2)
    @test !isless_tn(Interval(1, 2), Interval(1, 2))
    @test !isless_tn(Interval(1, 2), Interval(2, 3))
    @test !isless_tn(Interval(1, 2), 2)
    @test Interval(1, 2) ⪯ Interval(2, 3)
    @test Interval(2, 3) ⪰ Interval(1, 2)
    @test issubset_tn(Interval(1, 2), Interval(1, 2))
    @test Interval(1, 2) ⫃ Interval(1, 2)
    @test_throws FPTNException issubset(Interval(1, 2), Interval(1, 2))
    @test issubset_tn(Interval(1, 2), Interval(0, 3))
    @test !issubset_tn(Interval(1, 2), Interval(0, 1))
    @test is_strict_subset_tn(Interval(1, 2), Interval(0, 3))
    @test !is_strict_subset_tn(Interval(1, 2), Interval(1, 2))
    @test issupset_tn(Interval(1, 2), Interval(1, 2))
    @test_throws FPTNException Interval(1, 2) ⊇ Interval(1, 2)
    @test issupset_tn(Interval(0, 3), Interval(1, 2))
    @test !issupset_tn(Interval(0, 1), Interval(1, 2))
    @test is_strict_supset_tn(Interval(0, 3), Interval(1, 2))
    @test !is_strict_supset_tn(Interval(1, 2), Interval(1, 2))
    # isdisjoint
    @test isdisjoint(Interval(1, 2), Interval(3, 4))
    @test !isdisjoint(Interval(1, 2), Interval(2, 3))
    @test !isdisjoint(Interval(1, 2), Interval(1, 2))
    # hull
    @test hull(Interval(1, 2), Interval(3, 4)) === Interval(1, 4)
    @test hull(Interval(1, 2), Interval(2, 3)) === Interval(1, 3)
    @test hull(Interval(1, 2), Interval(1, 2)) === Interval(1, 2)
    @test hull(Interval(1, 2), Interval(3.0, 4.0), Interval(5, 6)) === Interval(1.0, 6.0)
    # intersect
    @test intersect(Interval(1, 2), Interval(3, 4)) === emptyset(Interval{Int})
    @test intersect(Interval(1, 2), Interval(2, 3)) === Interval(2, 2)
    @test intersect(Interval(1.0, 3.0), Interval(2, 4)) === Interval(2.0, 3.0)
    @test intersect(Interval(1, 5), Interval(2, 4), Interval(3, 10)) === Interval(3, 4)
    @test emptyset(Interval{Float32}) === Interval(Inf32, -Inf32)
    @test emptyset(Interval{Float64}) === Interval(Inf, -Inf)
    @test emptyset(Interval(1.0, 2.0)) === Interval(Inf, -Inf)
    @test isfinite_tn(Interval(1, 2))
    @test_throws FPTNException isfinite(Interval(1, 2))
    @test !isfinite_tn(Interval(1, Inf))
    @test !isfinite_tn(Interval(-Inf, 2))
    @test !isfinite_tn(Interval(-Inf, Inf))
    @test isinf_tn(Interval(1, Inf))
    @test_throws FPTNException isinf(Interval(1, Inf))
    @test isinf_tn(Interval(-Inf, 2))
    @test isinf_tn(Interval(-Inf, Inf))
    @test !isinf_tn(Interval(1, 2))
    @test isnan_tn(Interval(NaN, 2))
    @test_throws FPTNException isnan(Interval(NaN, 2))
    @test isnan_tn(Interval(1, NaN))
    @test isnan_tn(Interval(NaN, NaN))
    @test !isnan_tn(Interval(1, 2))
    @test !isnan_tn(Interval(1, Inf))

    @test x ≐ +x
    @test -x ≐ Interval(-3.0, -1.0)
    y = Interval(0x00, 0xff)
    @test_throws OverflowError -y

    # Comparisons between zero-width ThickNumbers and Reals
    @test Interval(1, 1) ≐ 1
    @test 1 ≐ Interval(1, 1)
    @test !(Interval(1, 1+eps()) ≐ 1)
    @test isequal_tn(Interval(1, 1), 1)
    @test isequal_tn(1, Interval(1, 1))
    @test !isequal_tn(1, Interval(1, 1+eps()))
    @test Interval(1, 1) ⩪ 1
    @test 1 ⩪ Interval(1, 1)
    @test 1 ⩪ Interval(1, 1+eps())

    # Arrays of ThickNumbers
    @test [Interval(1, 2), Interval(0, 1+eps())] ⩪ [Interval(1, 2*(1+eps())), Interval(0, 1)]
end

@testset "Specializations" begin
    @test loval(signbit(Interval(-1, 1))) === false
    @test hival(signbit(Interval(-1, 1))) === true
    @test eps(Interval(1.0, 1000.0)) === Interval(eps(1.0), eps(1000.0))
    @test clamp(Interval(-1, 4), 2, 3) === Interval(2, 3)
end

include(joinpath("extensions", "runtests.jl"))

cleanup()
