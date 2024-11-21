using NUnit.Framework;
using RestSharp;
using Newtonsoft.Json;
using System.Net;


public class ProductTests
{
    private RestClient _client;
    private const string BaseUrl = "https://fakestoreapi.com";


    public void Setup()
    {
        _client = new RestClient(BaseUrl);
    }


    public void GetAllProducts()
    {
        var request = new RestRequest("/products", Method.Get);
        var response = _client.Execute(request);

        Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);
        var products = JsonConvert.DeserializeObject<List<Product>>(response.Content);
        Assert.IsNotNull(products);
        Assert.IsNotEmpty(products);
    }


    public void CreateProduct()
    {
        var product = TestDataHelper.CreateTestProduct();
        var request = new RestRequest("/products", Method.Post);
        request.AddJsonBody(product);

        var response = _client.Execute(request);
        Assert.AreEqual(HttpStatusCode.Created, response.StatusCode);

        var createdProduct = JsonConvert.DeserializeObject<Product>(response.Content);
        Assert.IsNotNull(createdProduct);
        Assert.AreEqual(product.Title, createdProduct.Title);
    }


    public void UpdateProduct()
    {
        var productId = 1; // Assuming a product with ID 1 exists
        var updatedProduct = new { Title = "Updated Title" };
        var request = new RestRequest($"/products/{productId}", Method.Put);
        request.AddJsonBody(updatedProduct);

        var response = _client.Execute(request);
        Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);

        var product = JsonConvert.DeserializeObject<Product>(response.Content);
        Assert.AreEqual(updatedProduct.Title, product.Title);
    }


    public void DeleteProduct()
    {
        var productId = 1; // Assuming a product with ID 1 exists
        var request = new RestRequest($"/products/{productId}", Method.Delete);

        var response = _client.Execute(request);
        Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);

        var productRequest = new RestRequest($"/products/{productId}", Method.Get);
        var getProductResponse = _client.Execute(productRequest);

        Assert.AreEqual(HttpStatusCode.NotFound, getProductResponse.StatusCode);
    }


    public void GetProductCategories()
    {
        var request = new RestRequest("/products/categories", Method.Get);
        var response = _client.Execute(request);

        Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);
        var categories = JsonConvert.DeserializeObject<List<string>>(response.Content);
        Assert.IsNotNull(categories);
        Assert.IsNotEmpty(categories);
    }


    public void GetProductsSorted()
    {
        var request = new RestRequest("/products?sort=asc", Method.Get);
        var response = _client.Execute(request);

        Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);
        var products = JsonConvert.DeserializeObject<List<Product>>(response.Content);
        Assert.IsNotNull(products);
        Assert.IsTrue(products.SequenceEqual(products.OrderBy(p => p.Price)));
    }
}
