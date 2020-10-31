//
//  Math.swift
//  Simple Arithmetic
//
//  Created by Gabor Soulavy on 04/11/2015.
//  Copyright © 2015 Gabor Soulavy. All rights reserved.
//

import Foundation
import CoreGraphics

public enum MidpointRounding {
    case ToEven
    case AwayFromZero
}

// https://stackoverflow.com/a/61201420/420175
func %<N: BinaryFloatingPoint>(lhs: N, rhs: N) -> N {
    lhs.truncatingRemainder(dividingBy: rhs)
}

public class Math {

    public static let PI: Double = Double.pi
    public static let π: Double = PI
    public static let E: Double = M_E

    public class func Sqrt(_ x: Int) -> Double {
        return sqrt(Double(x))
    }

    public class func Sqrt(_ x: Double) -> Double {
        return sqrt(x)
    }

    public class func Sqrt(_ x: Float) -> Float {
        return sqrt(x)
    }

    public class func Sqrt(_ x: CGFloat) -> CGFloat {
        return sqrt(x)
    }

    public class func Abs(_ x: Double) -> Double {
        return abs(x)
    }

    public class func Abs(_ x: Float) -> Float {
        return abs(x)
    }

    private class func decimalPlaces(_ decimalPlaces: Int) -> Double {
        var result = 1.0
        if (decimalPlaces >= 0) {
            for _ in 0 ..< decimalPlaces {
                result *= 10
            }
        } else {
            for _ in 0 ..< abs(decimalPlaces) {
                result = result / 10
            }
        }
        return result
    }

    public class func Round(_ value: Double,
                            _ digits: Int,
                            _ midpointRounding: MidpointRounding = .ToEven) -> Double {
        let multiplier = Math.decimalPlaces(digits)
        var result: Int
        switch (midpointRounding) {
        case .ToEven:
            let sign = (value < 0) ? -1 : 1
            if (trunc(value) % 2 == 0) {
                result = Int(abs(value * multiplier) - 0.5) * sign
            } else {
                result = Int(abs(value * multiplier) + 0.5) * sign
            }
            return Double(result) / multiplier
        case .AwayFromZero:
            return round(multiplier * value) / multiplier
        }
    }

    public class func Log(_ x: Int) -> Double {
        return log(Double(x))
    }

    public class func Log(_ x: Double) -> Double {
        return log(x)
    }

    public class func Log(_ x: Float) -> Float {
        return log(x)
    }

    public class func Log(_ x: CGFloat) -> CGFloat {
        return log(x)
    }

    public class func Log10(_ x: Int) -> Double {
        return log10(Double(x))
    }

    public class func Log10(_ x: Double) -> Double {
        return log10(x)
    }

    public class func Log10(_ x: Float) -> Float {
        return log10(x)
    }

    public class func Log10(_ x: CGFloat) -> CGFloat {
        return log10(x)
    }

    public class func Log2(_ x: Int) -> Double {
        return log2(Double(x))
    }

    public class func Log2(_ x: Double) -> Double {
        return log2(x)
    }

    public class func Log2(_ x: Float) -> Float {
        return log2(x)
    }

    public class func Log2(_ x: CGFloat) -> CGFloat {
        return log2(x)
    }

    public class func Exp(_ x: Int) -> Double {
        return exp(Double(x))
    }

    public class func Exp(_ x: Double) -> Double {
        return exp(x)
    }

    public class func Exp(_ x: Float) -> Float {
        return exp(x)
    }

    public class func Exp(_ x: CGFloat) -> CGFloat {
        return exp(x)
    }

    public class func Floor(_ x: Int) -> Double {
        return floor(Double(x))
    }

    public class func Floor(_ x: Double) -> Double {
        return floor(x)
    }

    public class func Floor(_ x: Float) -> Float {
        return floor(x)
    }

    public class func Floor(_ x: CGFloat) -> CGFloat {
        return floor(x)
    }

    public class func Ceiling(_ x: Int) -> Double {
        return ceil(Double(x))
    }

    public class func Ceiling(_ x: Double) -> Double {
        return ceil(x)
    }

    public class func Ceiling(_ x: Float) -> Float {
        return ceil(x)
    }

    public class func Ceiling(_ x: CGFloat) -> CGFloat {
        return ceil(x)
    }

    public class func Pow(_ value: Int, _ power: Int) -> Double {
        return pow(Double(value), Double(power))
    }

    public class func Pow(_ value: Double, _ power: Double) -> Double {
        return pow(value, power)
    }

    public class func Pow(_ value: Float, _ power: Float) -> Float {
        return pow(value, power)
    }

    public class func Pow(_ value: CGFloat, _ power: CGFloat) -> CGFloat {
        return pow(value, power)
    }

    public class func Sin(_ angle: Double) -> Double {
        return sin(angle)
    }

    public class func Sin(_ angle: Float) -> Float {
        return sin(angle)
    }

    public class func Sin(_ angle: CGFloat) -> CGFloat {
        return sin(angle)
    }

    public class func Sinh(_ angle: Double) -> Double {
        return sinh(angle)
    }

    public class func Sinh(_ angle: Float) -> Float {
        return sinh(angle)
    }

    public class func Singh(_ angle: CGFloat) -> CGFloat {
        return sinh(angle)
    }

    public class func Asin(_ x: Double) -> Double {
        return asin(x)
    }

    public class func Asin(_ x: Float) -> Float {
        return asin(x)
    }

    public class func Asin(_ x: CGFloat) -> CGFloat {
        return asin(x)
    }

    public class func Cos(_ angle: Double) -> Double {
        return cos(angle)
    }

    public class func Cos(_ angle: Float) -> Float {
        return cos(angle)
    }

    public class func Cos(_ angle: CGFloat) -> CGFloat {
        return cos(angle)
    }

    public class func Cosh(_ angle: Double) -> Double {
        return cosh(angle)
    }

    public class func Cosh(_ angle: Float) -> Float {
        return cosh(angle)
    }

    public class func Cosh(_ angle: CGFloat) -> CGFloat {
        return cosh(angle)
    }

    public class func Acos(_ x: Double) -> Double {
        return acos(x)
    }

    public class func Acos(_ x: Float) -> Float {
        return acos(x)
    }

    public class func Acos(_ x: CGFloat) -> CGFloat {
        return acos(x)
    }

    public class func Tan(_ angle: Double) -> Double {
        return tan(angle)
    }

    public class func Tan(_ angle: Float) -> Float {
        return tan(angle)
    }

    public class func Tan(_ angle: CGFloat) -> CGFloat {
        return tan(angle)
    }

    public class func Tanh(_ angle: Double) -> Double {
        return tanh(angle)
    }

    public class func Tanh(_ angle: Float) -> Float {
        return tanh(angle)
    }

    public class func Tanh(_ angle: CGFloat) -> CGFloat {
        return tanh(angle)
    }

    public class func Atan(_ x: Double) -> Double {
        return atan(x)
    }

    public class func Atan(_ x: Float) -> Float {
        return atan(x)
    }

    public class func Atan(_ x: CGFloat) -> CGFloat {
        return atan(x)
    }

    public class func Atan2(_ x: Double, _ y: Double) -> Double {
        return atan2(x, y)
    }

    public class func Truncate(_ x: Double) -> Double {
        return trunc(x)
    }

    public class func Truncate(_ x: Float) -> Float {
        return trunc(x)
    }

    public class func Truncate(_ x: CGFloat) -> CGFloat {
        return trunc(x)
    }

    public class func Max<T:Comparable>(_ x: T, _ y: T) -> T {
        return max(x, y)
    }

    public class func Min<T:Comparable>(_ x: T, _ y: T) -> T {
        return min(x, y)
    }
}

public extension Math {
    static func MoveToRange<T>(x variable: T? = nil, min: T?, max: T?) -> T? where T:Comparable {
        if variable == nil || min == nil || max == nil {
            return nil
        }
        let floor = (variable! < min!) ? min! : variable!
        let ceiling = (floor > max!) ? max! : floor
        return ceiling
    }
}
