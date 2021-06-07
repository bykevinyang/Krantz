struct Stats: CustomStringConvertible {
  let values: [Double]
  
  init (values: [Double]){
    self.values = values
  }

  var description: String {
      return("\(values)")
    }

  func sum()->Double{
    var sum: Double = 0
    for num in values{
      sum += num
    }
    return(sum)
  }

  func mean() -> Double{
    let total = sum()
    return(total/Double(values.count))
  }

  func median() -> Double{
    let sorted_list:[Double] = values.sorted()
    let midpoint = sorted_list.count/2
    if sorted_list.count % 2 == 0 {
      let mid_average = (sorted_list[midpoint]+sorted_list[midpoint-1])/2
      return(mid_average)
    }
    else{
      return(sorted_list[midpoint])
    }
  }

  func standardDeviation() -> Double{
    //let sum_nums = sum(values)
    let mean_nums = mean()
    let sigma_list = values.map{($0 - mean_nums)*($0 - mean_nums)} // Maps operations in sigma to each element in array

    let sum = sigma_list.reduce(0, +) // Gets sum of mapped list using reduce routine
    var stdev = sum/Double(values.count-1)
    stdev = stdev.squareRoot()
    return(stdev)
  }
  
  func pollardRho(_ n: Int)->Bool{
    var x = 2
    var y = 2
    var d = 1
    
    if n < 0{
      return false
    }

    if n == 1{
      return false
    }

    if n % 2 == 0 && n != 2 {
      return false
    }

    if n % 5 == 0 && n != 5 {
      return false
    }

    while d == 1{
      x = pseudoRandomNum(x, n)
      y = pseudoRandomNum(pseudoRandomNum(y, n), n)
      d = gcd(abs(x-y), n)
    }

    if d != n {
      return false
    }
    else{
      return true
    }
  }

    func pseudoRandomNum(_ x:Int, _ n:Int)-> Int{
      return((x*x + 1) % n)
    }

    func gcd(_ m: Int, _ n: Int) -> Int {
      var a = 0
      var b = max(m, n)
      var r = min(m, n)

      while r != 0 {
        a = b
        b = r
        r = a % b
      }
      return b
    }

  func primes()-> [Int]{
    let iterVals: Set = Set(values)
    var primes: [Int] = []

    var noRepeatsPrimes: [Int] = []

    for num in iterVals{
      let integer = Int(num)
      if pollardRho(integer){
        primes.append(integer)
      }
    }
    let noRepeats = Set(primes)
    for item in noRepeats{
      noRepeatsPrimes.append(Int(item))
    }

    return(noRepeatsPrimes)
  }

    func internal_median (_ list: [Double]) -> (indice: Int, val: Double, isOdd: Bool){
      let sorted_list:[Double] = list.sorted()
      let midpoint = sorted_list.count/2
      if sorted_list.count % 2 == 0 {
        let mid_average = (sorted_list[midpoint]+sorted_list[midpoint-1])/2
        return(indice: midpoint, val: mid_average, isOdd: false)
      }
      else{
        return(indice: midpoint, val: sorted_list[midpoint], isOdd: true)
      }

    }

  func five() -> (smallest: Double, q1: Double, median: Double, q3: Double, largest:
  Double){
    let med = internal_median(values)
    let sorted_list = values.sorted()

    var upper_res: Double = -1
    var lower_res: Double = -1
    
    let median = med.1
    if med.2 == true{
      // let lower = Array(sorted_list[0...med.0])
      // let upper = Array(sorted_list[med.0...])
      let lower = Array(sorted_list[0..<med.0])
      let upper = Array(sorted_list[((med.0)+1)...])

      lower_res = internal_median(lower).1
      upper_res =  internal_median(upper).1
    }else{
      // let lower = Array(sorted_list[0...med.0])
      // let upper = Array(sorted_list[med.0...])
      let lower = Array(sorted_list[0..<med.0])
      let upper = Array(sorted_list[(med.0)...])

      lower_res = internal_median(lower).1
      upper_res =  internal_median(upper).1
    }

    // print(median)

    return(smallest: sorted_list[0], q1: lower_res, median: median, q3: upper_res, largest:sorted_list.last!)
  }

}