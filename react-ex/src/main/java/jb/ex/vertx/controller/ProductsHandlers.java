package jb.ex.vertx.controller;

import io.vertx.core.Handler;
import io.vertx.core.http.HttpServerResponse;
import io.vertx.ext.web.RoutingContext;

import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Service;

@Profile("vertx")
public class ProductsHandlers {

	@Service
	public static class GET implements Handler<RoutingContext> {
		public void handle(RoutingContext routingContext) {
			HttpServerResponse response = routingContext.response();
			response.putHeader("content-type", "application/json");

			// Write to the response and end it
			response.end("{\"id\":101, \"serialNo\":\"a34s4\"}");
		}
	}
	
	@Service
	public static class POST implements Handler<RoutingContext> {
		public void handle(RoutingContext routingContext) {
			HttpServerResponse response = routingContext.response();
			response.putHeader("content-type", "application/json");

			// Write to the response and end it
			response.end("{\"status\": \"1\"}");
		}
	}
	
}
