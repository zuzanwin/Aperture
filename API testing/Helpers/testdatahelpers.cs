public static class TestDataHelper
{
    public static Product CreateTestProduct()
    {
        return new Product
        {
            Title = "Test Product",
            Price = 99.99,
            Description = "A product used for testing",
            Category = "electronics",
            Image = "https://via.placeholder.com/150"
        };
    }
}
