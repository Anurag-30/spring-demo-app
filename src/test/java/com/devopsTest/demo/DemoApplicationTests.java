package com.devopsTest.demo;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.util.Assert;

@SpringBootTest
class DemoApplicationTests {

	@Test
	void contextLoads() {
	}


	@Test
	public void TestGreet() {
		DemoApplication appVersion = new DemoApplication();
		Assert.hasText("Hello World", appVersion.hello("World"));
	}

}
