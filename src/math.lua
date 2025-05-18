function AddVectors(v1, v2)
    return {
        x = v1.x + v2.x,
        y = v1.y + v2.y
    }
end

function VectorAdd(v, n)
    return {
        x = v.x + n,
        y = v.y + n
    }
end

function SubtractVectors(v1, v2)
    return {
        x = v1.x - v2.x,
        y = v1.y - v2.y
    }
end

function VectorSubtract(v, n)
    return {
        x = v.x - n,
        y = v.y - n
    }
end

function MultiplyVectors(v1, v2)
    return {
        x = v1.x * v2.x,
        y = v1.y * v2.y
    }
end

function VectorMultiply(v, n)
    return {
        x = v.x * n,
        y = v.y * n
    }
end

function VectorRotate(v, r)
    return {
        x = v.x * math.cos( r ) - v.y * math.sin( r ),
        y = v.x * math.sin( r ) + v.y * math.cos( r )
    }
end

function VectorRotateAroundPoint(v, r, dx, dy)
    return {
        x = ((v.x - dx) * math.cos( r ) - (v.y - dy) * math.sin( r )) + dx,
        y = ((v.x - dx) * math.sin( r ) + (v.y - dy) * math.cos( r )) + dy
    }
end

function VectorDot(v1, v2)
    return v1.x * v2.x + v1.y * v2.y
end

function VectorDotAxis(v, axis)
    return axis.direction.x * (v.x - axis.origin.x) + axis.direction.y * (v.y - axis.origin.y)
end

function VectorMagnitude(v)
    return math.sqrt( v.x * v.x + v.y * v.y )
end

function VectorNegate(v)
    return {
        x = v.x * -1,
        y = v.y * -1
    }
end

function VectorNormalize(v)
    local magnitude = VectorMagnitude( v )
    return {
        x = v.x / magnitude,
        y = v.y / magnitude
    }
end