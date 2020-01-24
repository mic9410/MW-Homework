## Michal Foryt
#import Pkg;
#Pkg.add("Distributions")
using Distributions

function simulateOneRun(m, s, S)
    pd = Poisson(20)
    h, c = 0.1, 2.0 # storage cost & sale price
    p = 0.50 # probability of delivery
    K, k = 40.0, 1.0 # fixed and variable order cost
    Xj, Yj = S, 0.0 # stock in the morning and in the evening
    profit = 0.0 # cumulated profit.
    for  j in 1:m
        Yj = Xj - rand(pd) # subtract demand for the day.
        Yj < 0.0 && (Yj = 0.0) # lost demand.
        profit += c * (Xj - Yj) - h * Yj
        if Yj < s && rand()< p # we have a successful order.
            profit -= K + k * (S - Yj)
            Xj = S
        else
            Xj = Yj
        end
    end
    profit / m
end

function simulateMultipleRuns(n, m)
    #Iterators
    i = m
    j = m

    # Temporary arrays
    simulation_results = []
    ss_array = []
    for s in 0.0:i:200.0  # s - point when we need to place order
        for S in 100.0:j:300.0  # S - target level
            single_simulation_result = simulateOneRun(n, s, S)
            push!(ss_array, [s,S])
            push!(simulation_results, single_simulation_result)
        end
    end

    # Find of best solution from the array
    index = findall(elem->elem==maximum(simulation_results), simulation_results)
    # Write to the file
    io = open("michal_foryt_84172.txt", "w");
    result_text = string(ss_array[index], " - MAX REVENUE: ", maximum(simulation_results))
    write(io, result_text);
    close(io);
    println(result_text)
end

simulateMultipleRuns(10_000_000, 50.0)

