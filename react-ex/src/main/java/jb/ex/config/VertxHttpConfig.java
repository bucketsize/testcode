package jb.ex.config;

import io.vertx.core.Handler;
import io.vertx.core.Vertx;
import io.vertx.core.http.HttpServer;
import io.vertx.core.http.HttpServerOptions;
import io.vertx.core.http.HttpServerRequest;
import io.vertx.ext.web.Router;
import io.vertx.ext.web.handler.BodyHandler;
import jb.ex.vertx.controller.ProductsHandlers;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;
import org.springframework.context.annotation.Profile;

@Configuration
@Import({BootConfig.class})
@Profile("vertx")
public class VertxHttpConfig {
	private static final Logger LOG = LoggerFactory.getLogger(VertxHttpConfig.class);

	@Autowired
	ProductsHandlers.GET getProductsHandler;
	
	@Autowired
	ProductsHandlers.POST postProductsHandler;
	
	@Bean
	public HttpServer vertxHttpServer(){
		LOG.info("starting vertxHttpServer ...");
		Vertx vertx = Vertx.vertx();

		Router router = Router.router(vertx);
		router.route().handler(BodyHandler.create());
		router.get("/products/:productID").handler(getProductsHandler);
		router.post("/products/new").handler(postProductsHandler);
		
		HttpServerOptions opts = new HttpServerOptions()
				.setAcceptBacklog(10000)
				.setHost("0.0.0.0")
				.setPort(18080)
				.setReceiveBufferSize(8192*2)
				.setSendBufferSize(8192*2)
				.setSoLinger(60)
				.setTcpKeepAlive(true)
				.setUsePooledBuffers(true);
		
		HttpServer server = vertx.createHttpServer(opts)
				.requestHandler(new RouteHandler(router));

		server.listen();

		return server;
	}

	// this is how to start a Spring App without SpringBoot
	public static void main(String[] args){
		AnnotationConfigApplicationContext ctx = new AnnotationConfigApplicationContext();
		ctx.register(VertxHttpConfig.class);
		try{
			ctx.refresh();
		}catch(Exception e){
			ctx.close();
		}
	}

	private static class RouteHandler implements Handler<HttpServerRequest> {
		private final Router router;

		public RouteHandler(Router r){
			router = r;
		}

		public void handle(final HttpServerRequest request) {
			router.accept(request);

		}
	}
}
