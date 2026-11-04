using Test
using HTTP
using PaperHound: build_rss_arxiv_url

@testset "fetch.jl" begin
    @testset "build_rss_arXiv_url" begin
        @testset "single category" begin
            @test build_rss_arxiv_url(["cond-mat"]) ==
                  "https://rss.arxiv.org/rss/cond-mat"
            @test build_rss_arxiv_url(["cs.AI"])    ==
                  "https://rss.arxiv.org/rss/cs.AI"
        end

        @testset "multiple categories joined with '+'" begin
            @test build_rss_arxiv_url(["cond-mat", "quant-ph"]) ==
                  "https://rss.arxiv.org/rss/cond-mat+quant-ph"
            @test build_rss_arxiv_url(["cs.AI", "cs.CL", "cs.LG"]) ==
                  "https://rss.arxiv.org/rss/cs.AI+cs.CL+cs.LG"
        end

        @testset "returns a parseable URL" begin
            url = build_rss_arxiv_url(["cs.AI", "cs.CL"])
            @test HTTP.URI(url) isa HTTP.URI  # не бросает исключение — значит, синтаксически валиден
        end

        @testset "empty input throws ArgumentError" begin
            @test_throws ArgumentError build_rss_arxiv_url(String[])
        end
    end
end