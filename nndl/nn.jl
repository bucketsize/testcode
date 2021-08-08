struct NeuralNet
    L :: Vector{Int64}
    W :: Vector{Matrix{Float32}}
    B :: Vector{Vector{Float32}}
end
function sigmoid(x::Float32)
    1/(1+exp(-x))
end
function relu(x::Float32)
    if x > 0
        x
    else
        0
    end
end
function sq(x::Float32)
    x*x
end
function createNN(L::Vector{Int64})::NeuralNet
    local W = []
    local B = []
    for (j, i) in zip(L[2:end], L[1:length(L)-1])
        push!(W, rand(Float32, j, i))
        push!(B, rand(Float32, j))
    end
    NeuralNet(L, W, B)
end
function descNN(nn::NeuralNet)
    println("layers:", nn.L)
    println("weights:", nn.W)
    println("bias:", nn.B)
end
function feedForward(nn::NeuralNet,
                     xs::Vector{Float32})::Vector{Float32}
    local y = xs
    for (w, b) in zip(nn.W, nn.B)
        y = broadcast(relu, w * y + b)
    end
    y
end
function costi(nn::NeuralNet,
               xs::Vector{Float32},
               ys::Vector{Float32},
               n::Int64)::Vector{Float32}
    local as = feedForward(nn, xs)
    local c = (1/2*n) * broadcast(sq, (ys - as))
    #println("costi:", typeof(c), size(c), c)
    c
end
function cost(nn::NeuralNet,
              xss::Vector{Vector{Float32}},
              yss::Vector{Vector{Float32}})::Vector{Float32}
    local cs = zeros(Float32, length(yss))
    for (xs, ys) in zip(xss, yss)
        cs += costi(nn, xs, ys, length(xss))
    end
    cs
end


nn = createNN([3, 5, 2])
c = cost(nn,
         [
             Float32[0.1, 0.8, 0.7],
             Float32[0.2, 0.5, 0.6]
         ],
         [
             Float32[0.8, 0],
             Float32[0.7, 0]
         ]
         )

println(c)
