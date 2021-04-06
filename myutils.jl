module my

import CSV, Glob
using DataFrames

function helloworld()
    println("Hello, world!")
end

function collect_csvfiles(files)
    df = DataFrame()
    for file in files
        append!(df, DataFrame(CSV.File(file)), cols=:union)
    end
    df
end

end



module mygurobi

using JuMP
import Gurobi

function get_modelinfo(model)
    nothing
end

function get_output(model)
    nothing
end

end



module myplot

using Plots, Plots.PlotMeasures
ENV["GKSwstype"] = "nul"

function performance_profile(   X; 
                                filename=nothing, 
                                title="", label=nothing, xlabel=nothing, ylabel=nothing, 
                                legend=:bottomright, left_margin=5mm, bottom_margin=5mm,
                                xaxis=nothing, yaxis=nothing)
    (m,n) = size(X)
    Y = 0:1/m:1
    X_sorted = vcat(zeros(1,n), sort(X, dims=1))

    fig = plot( X_sorted, Y, linetype=:steppre, title=title, xlabel=xlabel, ylabel=ylabel, label=reshape(label, 1, :), 
                legend=legend, left_margin=left_margin, bottom_margin=bottom_margin)
    
    isnothing(xaxis) ? xaxis!([0,maximum(X)]) : xaxis!(xaxis)
    isnothing(yaxis) ? yaxis!([0,1]) : yaxis!(yaxis)
    
    if !isnothing(filename)
        savefig(filename)
    end
    
    fig
end

end




# import .my, .myplot
# using Plots

# function main(args)
#     my.helloworld()
#     df = my.collect_csvfiles( Glob.glob("../twocommodity/20210325_1/*.csv") )
#     display(df[1:10,:])
#     println("")

#     # X = rand(10,3)
#     # label = ["x" "y" "z"]
#     # fig = myplot.performance_profile(X, filename="test.png", xaxis=[0,0.5])
#     # println(typeof(fig))
#     # savefig(fig, "test2.png")
# end

# main(ARGS)