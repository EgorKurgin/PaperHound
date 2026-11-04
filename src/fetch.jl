# fetch.jl 

# Build the full arXiv RSS feed URL for `category`;
# throw ArgumentError if `category` is empty.
function build_rss_arxiv_url(category::AbstractVector{<:AbstractString})::String 
    isempty(category) && throw(ArgumentError("categories must be non-empty"))

    return "https://rss.arxiv.org/rss/" * join(category, "+")
end

function validate_response(response)

end

function fetch_rss_body(url; timeout, headers)

end

function download_rss(url; timeout, max_retries, retry_delay)::String 

end