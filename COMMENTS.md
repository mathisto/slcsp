# Instructions
- In this directory, run `./make-it-so` from the command line

# Opportunities of Optimization (The Root of all Evil)
- This could be done purely relationally in SQL but would be a bit more opaque in its implementation.
- If lookup list grows in scale, I would optimize the strategy for querying. Grabbing all the zips in a list, you could perform a single query to the DB for all matches `IN (list of zips)`. You could then iterate in memory over each subset and let ruby handle the rest.
- If this got any larger, where seed files were along the TB scale or higher, I would:
  1. Grep out non silver plans
  2. Use `sed` to concat `state` and `rate_area` columns into a single string.
  3. Make `plan_zips` a first class table vice a view.
  4. Add an index on `zipcode`.
