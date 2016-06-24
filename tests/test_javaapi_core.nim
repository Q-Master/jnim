import jbridge,
       javaapi.core,
       common,
       unittest

suite "javaapi.core":
  setup:
    if not isJNIThreadInitialized():
      initJNIForTests()
    
  test "javaapi.core - Object":
    let o1 = Object.jnew
    let o2 = Object.jnew
    check: not o1.toString.equals(o2.toString)
    check: not o1.equals(o2)
    check: o1.getClass.equals(o2.getClass)

  test "javaapi.core - String":
    let s1 = String.jnew("Hi")
    let s2 = String.jnew("Hi")
    let s3 = String.jnew("Hello")
    # Check inheritance
    check: s1 of String
    check: s1 of Object
    # Check operations
    check: $s1 == "Hi"
    check: s1.equals(s2)
    check: not s2.equals(s3)

  jclass ExceptionTestClass of Object:
    proc throwEx(msg: string) {.`static`.}

  test "javaapi.core - Exception":
    expect(JavaException):
      ExceptionTestClass.throwEx("test")
    try:
      ExceptionTestClass.throwEx("test")
    except JavaException:
      let ex = getCurrentJVMException()
      check: ex.getStackTrace.len == 1
