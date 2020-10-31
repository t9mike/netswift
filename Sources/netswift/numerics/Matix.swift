struct Matix {
    let rows: Int, columns: Int
    var grid: [Double]

    init(rows: Int, columns: Int) {
        self.rows = rows; self.columns = columns

        grid = Array(repeating: 0.0, count: rows * columns)
    }

    func AreValid(row: Int, _ column: Int) -> Bool {
        return IsValid(value: row, rows) && IsValid(value: column, columns)
    }

    private func IsValid(value: Int, _ axis: Int) -> Bool {
        return value >= 0 && value < axis
    }

    subscript(row: Int, column: Int) -> Double {
        get {
            assert(AreValid(row: row, column), "Index is out of Range")
            return grid[(row * columns) + column]
        } set(value) {
            assert(AreValid(row: row, column), "Index is out of Range")
            grid[(row * columns) + column] = value
        }
    }
}
