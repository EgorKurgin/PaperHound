# Build the full arXiv RSS feed URL for `category`;
# throw ArgumentError if `category` is empty.
function build_rss_arxiv_url(category::AbstractVector{<:AbstractString})::String 
    isempty(category) && throw(ArgumentError("categories must be non-empty"))

    return "https://rss.arxiv.org/rss/" * join(category, "+")
end

# Fetch the RSS feed at `url`; retry up to `max_retries` times
# with `retry_delay` seconds between attempts.
# Throw ArgumentError if `max_retries < 1`;
# throw ErrorException if all attempts fail.
function download_rss(url; timeout=30.0, max_retries=3, retry_delay=2.0)
    max_retries >= 1 || throw(ArgumentError("max_retries must be ≥ 1"))

    last_error = nothing 
    for attempt in 1:max_retries
        try
            @info "Fetching feed: $url (attempt $attempt/$max_retries)"
            response = HTTP.get(url;
                                connect_timeout=timeout,
                                read_idle_timeout=timeout,
                                request_timeout=timeout * 2)

            if response.status != 200
                error("Attempt $attempt failed: HTTP $(response.status)")
            end
            return String(response.body)
        catch e 
            last_error = e
            @warn "Attempt $attempt failed: $(sprint(showerror, e))"
            attempt < max_retries && sleep(retry_delay)
        end
    end

    error("Failed to fetch feed after $max_retries attempts: " *
          sprint(showerror, last_error))
end