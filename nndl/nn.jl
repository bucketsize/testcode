mutable struct NeuralNet
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
    println("=========== NN =============")
    println("layers:  ", nn.L)
    println("weights: ", nn.W)
    println("bias:    ", nn.B)
end
function descTP(C, dC, dW, dB)
    println("------------ tmp -----------")
    println("C:  ", C)
    println("dC: ", dC)
    println("dW: ", dW)
    println("dB: ", dB)
end
function feedForward(nn::NeuralNet,
                     xs::Vector{Float32})::Vector{Float32}
    local y = xs
    for (w, b) in zip(nn.W, nn.B)
        y = broadcast(relu, w * y + b)
    end
    y
end
function cost(nn::NeuralNet,
              xss::Vector{Vector{Float32}},
              yss::Vector{Vector{Float32}})::Float32
    local c = Float32(0)
    local n = length(yss)
    for (xs, ys) in zip(xss, yss)
        local as = feedForward(nn, xs)
        local cx = sum(broadcast(sq, (ys - as)))
        c += cx
    end
    c / (2*n)
end
function gradientDescent(nn::NeuralNet,
                         xss::Vector{Vector{Float32}},
                         yss::Vector{Vector{Float32}},
                         lR::Float32,
                         N::Int64)::Float32
    descNN(nn)
    local C  = cost(nn, xss, yss)
    local dW = lR*nn.W
    local dB = lR*nn.B
    nn.W += dW
    nn.B += dB

    for i in 1:N
        descNN(nn)
        local C1 = cost(nn, xss, yss)
        local dC = C1 - C

        divDeltaCby(x) = (dC/x)
        local dW1 = []
        for idW in dW
            local grCw = broadcast(divDeltaCby, idW)
            push!(dW1, - lR*grCw)
        end
        dW = dW1

        local dB1 = []
        for idB in dB
            local grCb = broadcast(divDeltaCby, idB)
            push!(dB1, - lR*grCb)
        end
        dB = dB1

        nn.W += dW
        nn.B += dB
        C = C1

        descTP(C, dC, dW, dB)
    end
    return C
end

trX =
    [
        Float32[0.1, 0.8, 0.7],
        Float32[0.2, 0.5, 0.6]
    ]
trY =
    [
        Float32[0.8, 0.21],
        Float32[0.7, 0.12]
    ]

nn = createNN([3, 5, 2])
fc = gradientDescent(nn, trX, trY, Float32(0.01), 10)

println(fc)
