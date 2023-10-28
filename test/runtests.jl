using PTY-QoL
using Test

@testset "//" begin
    @test 1 // 2 isa Rational
    @test 1.0 // 2.0 == 1 // 2
end
