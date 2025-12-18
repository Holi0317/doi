export function InsertForm() {
  return (
    <form method="post" action="/basic/insert">
      <label>
        <input type="url" name="url" />
      </label>

      <input type="submit" value="Add link" />
    </form>
  );
}
