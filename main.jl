using Optim, BilevelBenchmark
import Printf.@printf

evals_ul = 0
evals_ll = 0

function main()
	# problem number
	fnum = 1

	# bilevel problem settings
	D_ul = D_ll = 5
	bounds_ul, bounds_ll = bilevel_ranges(D_ul, D_ll, fnum)


	# upper level function
    F(x, y) = begin
    	global evals_ul += 1
    	bilevel_leader(x, y, fnum)
    end

	# lower level function
    f(x, y) = begin
    	global evals_ll += 1
    	bilevel_follower(x, y, fnum)
    end


    # nested problem
	FF(x) = begin
		y0 = bounds_ll[1,:] + ( bounds_ll[2,:] - bounds_ll[1,:]) .* rand(D_ll)

		result = optimize( z -> f(x, z), y0, LBFGS())
		y = result.minimizer

		F(x, y)
	end

	# start point
	x0 = bounds_ul[1,:] + ( bounds_ul[2,:] - bounds_ul[1,:]) .* rand(D_ul)

	# start optimization process
	result = optimize(FF , x0, LBFGS())

	# show results
	println("evals_ul: ", evals_ul)
	println("evals_ll: ", evals_ll)
	result




end

main()