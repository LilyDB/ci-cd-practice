from calculator import add, multiply

def test_add():
    assert add(2, 3) == 5
    assert add(-1, 1) == 0
    print("✅ Add tests passed")

def test_multiply():
    assert multiply(3, 4) == 12
    assert multiply(0, 5) == 0
    print("✅ Multiply tests passed")

if __name__ == "__main__":
    test_add()
    test_multiply()
    print("All tests passed!")