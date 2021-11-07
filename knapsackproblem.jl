using JuMP
using GLPK

investment = [8, 14, 15, 12, 9, 20, 10, 9, 8, 14]
absolute_return = [0.4, 1.1, 1.3, 0.9, 5.8, 0.1, 4.8, 4.1, 7.3, 7.8]

budget = 45

n = length(investment)
model = Model(GLPK.Optimizer)

@variable(model, x[i=1:n] >=0 , binary=true)

@objective(model, Max, sum(absolute_return[i]*x[i] for i = 1:n))

@constraint(model, sum(investment[i]*x[i] for i = 1:n) <= budget)

optimize!(model)

#print(model)

println("Project\tReturn\tInvestment")
for i = 1:n
    if value(x[i]) > 0
        println(i,"\t", absolute_return[i],"\t",investment[i])
    end
end
println("-------------")
println("Budget:\t\t",budget)
println("Investment:\t", sum(value(x[i])*investment[i] for i = 1:n))
println("Return:\t\t", objective_value(model))
