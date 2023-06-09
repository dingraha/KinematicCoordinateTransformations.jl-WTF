using ForwardDiff: ForwardDiff
using FiniteDiff: FiniteDiff
using ReverseDiff: ReverseDiff

Test.@testset "ForwardDiff checks" begin

    Test.@testset "velocity" begin

        function position(t)
            t_scalar = only(t)
            x = [3.0, 4.0, 5.0]
            v = [1.0, 2.0, 3.0]

            trans0 = ConstantVelocityTransformation(5.0, StaticArrays.SVector{3, Float64}(0.0, 0.0, 0.0), v)

            M1 = StaticArrays.@SMatrix [8.0 1.0 3.0;
                                        3.0 6.0 9.0;
                                        4.0 7.0 10.0]
            trans1 = ConstantLinearMap(M1)

            t0 = 2.0
            ω = 2*pi
            θ = 5.0*pi/180.0
            trans2 = SteadyRotXTransformation(t0, ω, θ)

            t0 = 1.0
            ω = 3*pi
            θ = 3.0*pi/180.0
            trans3 = SteadyRotYTransformation(t0, ω, θ)

            t0 = 1.5
            ω = 4*pi
            θ = 4.0*pi/180.0
            trans4 = SteadyRotZTransformation(t0, ω, θ)

            trans = compose(t_scalar, trans4,
                        compose(t_scalar, trans3,
                            compose(t_scalar, trans2,
                                compose(t_scalar, trans1, trans0))))

            x_out = trans(t_scalar, x, false)

            return x_out
        end

        function velocity(t)
            t_scalar = only(t)
            x = [3.0, 4.0, 5.0]
            v = [1.0, 2.0, 3.0]

            M1 = StaticArrays.@SMatrix [8.0 1.0 3.0;
                                        3.0 6.0 9.0;
                                        4.0 7.0 10.0]
            trans1 = ConstantLinearMap(M1)

            t0 = 2.0
            ω = 2*pi
            θ = 5.0*pi/180.0
            trans2 = SteadyRotXTransformation(t0, ω, θ)

            t0 = 1.0
            ω = 3*pi
            θ = 3.0*pi/180.0
            trans3 = SteadyRotYTransformation(t0, ω, θ)

            t0 = 1.5
            ω = 4*pi
            θ = 4.0*pi/180.0
            trans4 = SteadyRotZTransformation(t0, ω, θ)

            trans = compose(t_scalar, trans4,
                        compose(t_scalar, trans3,
                            compose(t_scalar, trans2, trans1)))
                                

            x_out, v_out = trans(t_scalar, x, v, false)

            return v_out
        end

        t = [5.0]
        Test.@test all(velocity(t) .≈ ForwardDiff.jacobian(position, t)[:, 1])
    end

    Test.@testset "acceleration" begin

        function velocity(t)
            t_scalar = only(t)
            x = [3.0, 4.0, 5.0]
            v = [1.0, 2.0, 3.0]

            trans0 = ConstantVelocityTransformation(5.0, StaticArrays.SVector{3, Float64}(0.0, 0.0, 0.0), v)

            M1 = StaticArrays.@SMatrix [8.0 1.0 3.0;
                                        3.0 6.0 9.0;
                                        4.0 7.0 10.0]
            trans1 = ConstantLinearMap(M1)

            t0 = 2.0
            ω = 2*pi
            θ = 5.0*pi/180.0
            trans2 = SteadyRotXTransformation(t0, ω, θ)

            t0 = 1.0
            ω = 3*pi
            θ = 3.0*pi/180.0
            trans3 = SteadyRotYTransformation(t0, ω, θ)

            t0 = 1.5
            ω = 4*pi
            θ = 4.0*pi/180.0
            trans4 = SteadyRotZTransformation(t0, ω, θ)

            trans = compose(t_scalar, trans4,
                        compose(t_scalar, trans3,
                            compose(t_scalar, trans2,
                                compose(t_scalar, trans1, trans0))))
                                

            x_out, v_out = trans(t_scalar, x, [0.0, 0.0, 0.0], false)

            return v_out
        end

        function acceleration(t)
            t_scalar = only(t)
            x = [3.0, 4.0, 5.0]
            v = [1.0, 2.0, 3.0]
            a = [0.0, 0.0, 0.0]

            M1 = StaticArrays.@SMatrix [8.0 1.0 3.0;
                                        3.0 6.0 9.0;
                                        4.0 7.0 10.0]
            trans1 = ConstantLinearMap(M1)

            t0 = 2.0
            ω = 2*pi
            θ = 5.0*pi/180.0
            trans2 = SteadyRotXTransformation(t0, ω, θ)

            t0 = 1.0
            ω = 3*pi
            θ = 3.0*pi/180.0
            trans3 = SteadyRotYTransformation(t0, ω, θ)

            t0 = 1.5
            ω = 4*pi
            θ = 4.0*pi/180.0
            trans4 = SteadyRotZTransformation(t0, ω, θ)

            trans = compose(t_scalar, trans4,
                        compose(t_scalar, trans3,
                            compose(t_scalar, trans2, trans1)))
                                
            x_out, v_out, a_out = trans(t_scalar, x, v, a, false)

            return a_out
        end

        t = [5.0]
        Test.@test all(acceleration(t) .≈ ForwardDiff.jacobian(velocity, t)[:, 1])
    end

    Test.@testset "jerk" begin

        function acceleration(t)
            t_scalar = only(t)
            x = [3.0, 4.0, 5.0]
            v = [1.0, 2.0, 3.0]
            a = [0.0, 0.0, 0.0]

            trans0 = ConstantVelocityTransformation(5.0, StaticArrays.SVector{3, Float64}(0.0, 0.0, 0.0), v)

            M1 = StaticArrays.@SMatrix [8.0 1.0 3.0;
                                        3.0 6.0 9.0;
                                        4.0 7.0 10.0]
            trans1 = ConstantLinearMap(M1)

            t0 = 2.0
            ω = 2*pi
            θ = 5.0*pi/180.0
            trans2 = SteadyRotXTransformation(t0, ω, θ)

            t0 = 1.0
            ω = 3*pi
            θ = 3.0*pi/180.0
            trans3 = SteadyRotYTransformation(t0, ω, θ)

            t0 = 1.5
            ω = 4*pi
            θ = 4.0*pi/180.0
            trans4 = SteadyRotZTransformation(t0, ω, θ)

            trans = compose(t_scalar, trans4,
                        compose(t_scalar, trans3,
                            compose(t_scalar, trans2,
                                compose(t_scalar, trans1, trans0))))
                                

            x_out, v_out, a_out = trans(t_scalar, x, [0.0, 0.0, 0.0], a, false)

            return a_out
        end

        function jerk(t)
            t_scalar = only(t)
            x = [3.0, 4.0, 5.0]
            v = [1.0, 2.0, 3.0]
            a = [0.0, 0.0, 0.0]
            j = [0.0, 0.0, 0.0]

            M1 = StaticArrays.@SMatrix [8.0 1.0 3.0;
                                        3.0 6.0 9.0;
                                        4.0 7.0 10.0]
            trans1 = ConstantLinearMap(M1)

            t0 = 2.0
            ω = 2*pi
            θ = 5.0*pi/180.0
            trans2 = SteadyRotXTransformation(t0, ω, θ)

            t0 = 1.0
            ω = 3*pi
            θ = 3.0*pi/180.0
            trans3 = SteadyRotYTransformation(t0, ω, θ)

            t0 = 1.5
            ω = 4*pi
            θ = 4.0*pi/180.0
            trans4 = SteadyRotZTransformation(t0, ω, θ)

            trans = compose(t_scalar, trans4,
                        compose(t_scalar, trans3,
                            compose(t_scalar, trans2, trans1)))
                                
            x_out, v_out, a_out, j_out = trans(t_scalar, x, v, a, j, false)

            return j_out
        end

        t = [5.0]
        Test.@test all(jerk(t) .≈ ForwardDiff.jacobian(acceleration, t)[:, 1])
    end

    Test.@testset "Compare to FD" begin
        function f(x, v, a, j)
            t = 5.1
            M1 = StaticArrays.@SMatrix [8.0 1.0 3.0;
                                        3.0 6.0 9.0;
                                        4.0 7.0 10.0]
            trans1 = ConstantLinearMap(M1)

            t0 = 2.0
            ω = 2*pi
            θ = 5.0*pi/180.0
            trans2 = SteadyRotXTransformation(t0, ω, θ)

            t0 = 1.0
            ω = 3*pi
            θ = 3.0*pi/180.0
            trans3 = SteadyRotYTransformation(t0, ω, θ)

            t0 = 1.5
            ω = 4*pi
            θ = 4.0*pi/180.0
            trans4 = SteadyRotZTransformation(t0, ω, θ)

            M2 = StaticArrays.@SMatrix [3.0 2.0 1.0;
                                        4.0 4.0 8.0;
                                        4.5 7.1 10.2]
            trans5 = ConstantLinearMap(M2)

            trans = compose(t, trans5,
                        compose(t, trans4,
                            compose(t, trans3,
                                compose(t, trans2, trans1))))
                                
            return trans(t, x, v, a, j, false)
        end

        function f(X)
            x = @view X[1:3]
            v = @view X[4:6]
            a = @view X[7:9]
            j = @view X[10:12]
            
            return vcat(f(x, v, a, j)...)
        end

        X0 = [1.0, 2.0, 3.0,
              4.0, 5.0, 6.0,
              7.0, 8.0, 9.0,
              10.0, 11.0, 12.0]
        dfdx_fad = ForwardDiff.jacobian(f, X0)
        dfdx_cd = FiniteDiff.finite_difference_jacobian(f, X0, Val(:central))
        Test.@test all(isapprox.(dfdx_fad, dfdx_cd; rtol=1e-8))

        dfdx_cs = FiniteDiff.finite_difference_jacobian(f, X0, Val(:complex))
        Test.@test all(isapprox.(dfdx_fad, dfdx_cs; rtol=1e-12))

        dfdx_rad = ReverseDiff.jacobian(f, X0)
        Test.@test all(isapprox.(dfdx_rad, dfdx_fad; rtol=1e-12))
    end
end
