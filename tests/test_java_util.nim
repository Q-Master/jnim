import ../jnim,
       ../jnim/java/util,
       common,
       unittest
import ../jnim/java/lang except Exception
import sequtils except toSeq

suite "java.util":
  setup:
    if not isJNIThreadInitialized():
      initJNIForTests()

  test "java.util.List":
    let xs = ArrayList[string].new()
    discard xs.add("Hello")
    xs.add(1, "world")
    check: xs.get(0) == "Hello"
    check: xs.get(1) == "world"
    expect JavaException:
      discard xs.get(3)
    var s = newSeq[string]()
    let it = xs.toIterator
    while it.hasNext:
      s.add it.next
    check: s == @["Hello", "world"]
    discard xs.removeAll(ArrayList[string].new(["world", "!"]))
    check: xs.toSeq == @["Hello"]

  test "java.util.Map":
    let m = HashMap[Integer, string].new()
    discard m.put(1.jint, "A")
    discard m.put(2.jint, "B")
    discard m.put(3.jint, "C")
    check: m.get(1.jint) == "A"
    check: m.get(2.jint) == "B"
    check: m.get(3.jint) == "C"
    check: m.keySet.toSeq.mapIt(it.intValue) == @[1.jint, 2, 3]
    check: m.keySet.toSeq == @[1.jint, 2, 3].mapIt(Integer.new(it))
    check: m.values.toSeq == @["A", "B", "C"]
