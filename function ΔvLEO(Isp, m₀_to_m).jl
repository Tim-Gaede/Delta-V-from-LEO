# Timothy Gaede
# 2019-09-16
# TimGaede@gmail.com

using Formatting

#-------------------------------------------------------------------------------
# Yields result of a Δv from Low Earth Orbit
# given specfic impulse (in seconds) and
# initial-to-final rocket mass ratio

function ΔvLEO(Isp, mᵢ_to_m)
    
    # Unless otherwise implied, all physical units are of the kms system
    
    # Assumes Δv will be in the direction of Earth orbiting the Sun

    τ = 2π
    k = 1000
    alt_LEO = 200k # altitude (height above surface) at Low Earth Orbit
    hr = 60*60
    day = 24hr
    R🌏 = 6.3781 * 10^6
    a🌏 = 149_598_023.0k
    # The standard gravitational parameter, μ is equal to GM
    # μ is much more accurately known than either G or M.  Think about it.
    μ🌏 = 3.9860044188 * 10.0^14
    μ🌞 = 1.327124400189 * 10.0^20

    AU = 149_597_870_700.0

    yr = τ*√(a🌏^3 / μ🌞)

    Δv🚀🌏 = 9.80665*Isp*log(mᵢ_to_m) # change in speed of rocket wrt Earth



    rₒ🚀🌏 = R🌏 + alt_LEO
    vₒ🚀🌏 = √(μ🌏 / rₒ🚀🌏) # speed of rocket wrt Earth while in LEO



    # Perigee speed of rocket immediately after the engines finished their burn
    vₚ🚀🌏 = vₒ🚀🌏 + Δv🚀🌏

    n = vₚ🚀🌏 / vₒ🚀🌏 # velocity ratio
    n² = n^2

    if n² < 2 # Orbits the Earth

        rₐ🚀🌏 = rₒ🚀🌏 * n² / (2 - n²) # apogee
        a = (rₐ🚀🌏 + rₒ🚀🌏) / 2 # semi-major axis
        T = τ*√(a^3 / μ🌏) # oribital period

        if T < 10hr
            strT = format((T / hr), precision=5) * " hours"
        elseif T < 72hr
            strT = format((T / hr), precision=4) * " hours"
        elseif T < 10day
            strT = format((T / day), precision=5) * " days"
        else
            strT = format((T / day), precision=4) * " days"
        end

        alt_ap_km = (rₐ🚀🌏 - R🌏) / k # altitude at apogee in km


        if alt_ap_km < 1000
            strAlt = format(alt_ap_km, precision=2) * " km"
        elseif alt_ap_km < 10k
            strAlt = format(alt_ap_km, precision=1) * " km"
        elseif alt_ap_km < 100k
            alt_ap_km = convert(Int, floor(alt_ap_km))
            strAlt = format(alt_ap_km, commas=true) * " km"
        else
            return "The rocket has entered an unstable orbit\n" *
                   "about the Earth."
        end
        "The rocket will orbit the Earth with a period of \n" *
        strT * "\n\n" *
        "Its maximum altitude will be " * strAlt * "."

    elseif n² > 2 # Rocket escapes Earth.  Will it escape the Solar System?
        vₑ🚀🌏= √2vₒ🚀🌏  # escape speed from LEO
        v🌏🌞 = √(μ🌞 / AU) # Speed of Earth orbit around Sun
        v🚀🌏 = √(vₚ🚀🌏^2 - vₑ🚀🌏^2) # wrt Earth
        vₚ🚀🌞 = v🚀🌏 + v🌏🌞 # wrt Sun


        N = vₚ🚀🌞 / v🌏🌞 # velocity ratio
        N² = N^2

        if N² < 2 # Rocket orbits the Sun


            rₐ🚀🌞 = AU * N² / (2 - N²) # aphelion
            a = (rₐ🚀🌞 + AU) / 2 # semi-major axis
            T = τ*√(a^3 / μ🌞) # orbital period

            if T < 10yr
                strT = format((T / yr), precision=5) * " years"
            elseif T < 100yr
                strT = format((T / yr), precision=4) * " years"
            elseif T < 1000yr
                strT = format((T / yr), precision=3) * " years"
            elseif T < 10k*yr
                strT = format((T / yr), precision=2) * " years"
            elseif T < 100k*yr
                strT = format((T / yr), precision=1) * " years"
            else
                T_yr = convert(Int, floor(T / yr))
                strT = format(T_yr, commas=true) * " years"
            end

            a_AU = rₐ🚀🌞 / AU # aphelion in AU


            if a_AU < 10
                strAp = format(a_AU, precision=5) * " AU"
            elseif a_AU < 100
                strAp = format(a_AU, precision=4) * " AU"
            elseif a_AU < 1000
                strAp = format(a_AU, precision=3) * " AU"
            elseif a_AU < 10k
                strAp = format(a_AU, precision=2) * " AU"
            elseif a_AU < 100k
                strAp = format(a_AU, precision=1) * " AU"
            else
                a_AU = convert(Int, floor(a_AU))
                strAp = format(a_AU, commas=true) * " AU"
            end

            "The rocket will orbit the Sun " *
            "with a period of \n" * strT * ".\n\n" *
            "Its aphelion will be " * strAp * "."

        elseif N² > 2 # Rocket escapes the Solar System
            vₑ🌏🌞 = √2v🌏🌞 # Escape speed from Sun at one AU
            v∞🚀🌞 = √(vₚ🚀🌞^2 - vₑ🌏🌞^2) # Asymptopic speed
            v_AUperYr = v∞🚀🌞 / (AU / yr)

            if v_AUperYr < 10
                strAUperYr = format(v_AUperYr, precision=5) * " AU per year"
            elseif v_AUperYr < 100
                strAUperYr = format(v_AUperYr, precision=4) * " AU per year"
            elseif v_AUperYr < 1000
                strAUperYr = format(v_AUperYr, precision=3) * " AU per year"
            elseif v_AUperYr < 10k
                strAUperYr = format(v_AUperYr, precision=2) * " AU per year"
            else
                return "We're getting relativistic."
            end

            "The rocket will escape the Solar System\n" *
            "with a speed that " * "asymptotically approaches\n\n" *
            strAUperYr * "."

        else # N² == 2
            "Wow!\n\n" *
            "The rocket is right at the escape velocity of " *
            "the Solar System!"

        end


    else # n² == 2
        "Wow!\n\n" *
        "The rocket is right at the escape velocity of " *
        "the Earth!"

    end


end
#-------------------------------------------------------------------------------


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function main()
    println("\n", "-"^40, "\n")

    println(ΔvLEO(380, 3.2))
end
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
main() 
