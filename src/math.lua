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
        x = v.x * math.cos(r) + v.y * math.sin(r),
        y = v.x * math.sin(r) - v.y * math.cos(r)
    }
end

function VectorProject(v, line)
    local dotValue = line.direction.x * (v.x - line.origin.x) + line.direction.y * (v.y - line.origin.y)

    return {
        x = line.origin.x + line.direction.x * dotValue,
        y = line.origin.y + line.direction.y * dotValue
    }
end

function VectorMagnitude(v)
    return math.sqrt( v.x * v.x + v.y * v.y )
end