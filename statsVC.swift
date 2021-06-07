import Foundation

struct StatsVC{
  var data = [String : Stats]()

  func inputBreakdown(_ input: String)->(command: String, directory: String, data:[Double]){

    if input.last! == " "{
      print("\t Please input valid data")
      return("","",[])
    }

    let sep = input.components(separatedBy:" ")

    var directory = ""
    var numbers: [Double] = []
    let cmd = sep[0]
    if sep.count > 1{
      directory = sep[1]
    }
    if sep.count > 2{
      for num in 2..<sep.count{
        numbers.append(Double(sep[num])!)
      }
    }
    return(cmd, directory, numbers)
  }

  mutating func runStats(){
    let help_msg = """
                      Stats Commands:
                      
                      add name d1 d2 d3 ... - add a new stats data set
                      current name - set the current stats data set to name
                      sum - sum of current data set
                      mean - mean of current data set
                      median - median of current data set
                      stdev - standard deviation of current data set
                      primes - prime numbers in current data set
                      write fileName - write the stats data base to file fileName
                      read fileName - read the stats data base from file fileName
                      help - this help message
                      info - info report
                      five - gives five number summary on data
                      write - write the current database into a file
                      read - read and load a valid textfile into current database
                      quit - quit stats
                    """

    var current: String = ""

    print("Welcome to Stats!")
    var run = true

    while (run){
      print("Command...", terminator:"")
      let console = readLine()!
      let (command, directory, stats_data) = inputBreakdown(console)

      switch command{
        case "add":
          if stats_data.isEmpty{
            print("\t Please add in data")
          }else{
            self.data[directory] = Stats(values: stats_data)
          }

        case "current":
          if data[directory] != nil{
            current = directory
          }
          else{
            print("\t Please set a valid directory")
          }

        case "info":
          if data.isEmpty{
            print("\t You have not added any data")
          } else{
            for item in data.keys{
              if item != current{
              var dt = data[item]!.values
              dt = dt.sorted()
              print("\t" + item, dt)
              } else{
              if current != "" {
                var dt = data[item]!.values
                dt = dt.sorted()
                print("\t *" + current, dt)
                }
              }
            }
          }
  // [Key: Values]
        case "quit":
          run = false
          break
        
        case "sum":
          if current != ""{
            print("\t Sum is \(data[current]!.sum() as Any)")
          } else{
            print("\t Please set a directory")
          }

        case "mean":
          if current != ""{
            print("\t Mean is \(data[current]!.mean() as Any)")
          } else{
            print("\t Please set a directory")
          }
        
        case "median":
          if current != ""{
            print("\t Median is \(data[current]!.median() as Any)")
          } else{
            print("\t Please set a directory")
          }
        
        case "stdev":
          if current != ""{
            print("\t Standard Deviation is \(data[current]!.median() as Any)")
          } else{
            print("\t Please set a directory")
          }
        
        case "primes":
          if current != ""{
            print("\t Primes are \(data[current]!.primes().sorted() as Any)")
          } else{
            print("\t Please set a directory")
          }

        case "five":
          if current != ""{
              let (small, q1, median, q3, largest) = data[current]!.five()
              print("""
                      Smallest is \(small)
                      Quartile 1 is \(q1)
                      Median is \(median)
                      Quartile 3 is \(q3)
                      Largest is \(largest)
                    """)
            } else{
              print("\t Please set a directory")
            }
        
        case "write":
          var text_write: String = ""
          for key in data.keys{
            text_write.append(String(key))
            text_write.append(" ")

            var data_to_edit = String(data[key]!.description)
            data_to_edit.removeLast()
            data_to_edit.removeFirst()
            data_to_edit = data_to_edit.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)

            text_write.append(data_to_edit)
            text_write.append("\n")
          }
          if directory == ""{
            print("\t Please set a directory")
          }
          else{
            let output = writeTextFile(directory, data: text_write)
            if output != nil{
              print(output as Any)
            }
          }
        
        case "read":
          if directory == ""{
              print("\t Please set a directory")
            }else{
              let (msg, rawText, lines) = readTextFile(directory)
              if msg == ""{
                for item in lines{
                  let (cmd, directory, numbers) = inputBreakdown(item)
                  self.data[directory] = Stats(values: numbers)
                }
                
              }
              else{
                print("\t An error has occured")
              }
            }

        case "help":
          print(help_msg)

        default:
          print("\t Unrecognized Command")
      }

    }
  }
}

