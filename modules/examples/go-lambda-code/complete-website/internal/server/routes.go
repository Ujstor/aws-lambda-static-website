package server

import (
	"context"
	"github.com/a-h/templ"
	"github.com/aws/aws-lambda-go/events"
	chiadapter "github.com/awslabs/aws-lambda-go-api-proxy/chi"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"net/http"
	"portfolio-web/cmd/web"
)

func (s *Server) RegisterRoutes() *chi.Mux {
	r := chi.NewRouter()
	r.Use(middleware.Logger)

	fileServer := http.FileServer(http.FS(web.Files))
	r.Handle("/assets/*", fileServer)
	r.Get("/", templ.Handler(web.Portfolio()).ServeHTTP)

	return r
}

func (s *Server) HandleRequest(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	chiLambda := chiadapter.New(s.RegisterRoutes())
	return chiLambda.ProxyWithContext(ctx, req)
}
