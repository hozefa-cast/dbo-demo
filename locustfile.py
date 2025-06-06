from locust import HttpUser, task, between

class EvershopUser(HttpUser):
    wait_time = between(1, 3)

    @task(2)
    def view_homepage(self):
        self.client.get("/")

    @task(1)
    def view_product(self):
        self.client.get("/products/strutter")  # Replace with real slug
