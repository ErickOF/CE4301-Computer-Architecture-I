int main() {
    int a, i;
    const int b = 2;
    const int c = 3;
    const int d = 10;
    const int e = 5;
    const int f = 8;

    for (i = 1; i <= 1000000; i++) {
        a = b + c * d / e - f;
    }

    return 0;
}
