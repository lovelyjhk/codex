const form = document.querySelector("#postForm");
const postList = document.querySelector("#postList");
const postCount = document.querySelector("#postCount");
const refreshButton = document.querySelector("#refreshButton");
const detail = document.querySelector("#detail");
const detailEmpty = document.querySelector("#detailEmpty");
const detailState = document.querySelector("#detailState");
const detailTitle = document.querySelector("#detailTitle");
const detailMeta = document.querySelector("#detailMeta");
const detailContent = document.querySelector("#detailContent");
const deleteButton = document.querySelector("#deleteButton");
const message = document.querySelector("#message");

let selectedPostId = null;

function showMessage(text, isError = false) {
  message.textContent = text;
  message.style.color = isError ? "#c2413c" : "#147e7f";
  if (text) {
    window.clearTimeout(showMessage.timer);
    showMessage.timer = window.setTimeout(() => {
      message.textContent = "";
    }, 2600);
  }
}

async function requestJson(url, options = {}) {
  const response = await fetch(url, {
    headers: {
      "Content-Type": "application/json",
      ...(options.headers || {}),
    },
    ...options,
  });

  if (!response.ok) {
    let detailText = "요청을 처리하지 못했습니다.";
    try {
      const errorBody = await response.json();
      detailText = errorBody.detail || detailText;
    } catch {
      detailText = response.statusText || detailText;
    }
    throw new Error(detailText);
  }

  if (response.status === 204) {
    return null;
  }

  return response.json();
}

function renderEmptyList() {
  postList.innerHTML = '<div class="empty">등록된 게시글이 없습니다.</div>';
  postCount.textContent = "0건";
}

function renderList(posts) {
  postCount.textContent = `${posts.length}건`;

  if (posts.length === 0) {
    renderEmptyList();
    return;
  }

  postList.innerHTML = posts
    .map((post) => {
      const activeClass = post.id === selectedPostId ? " active" : "";
      return `
        <button class="post-item${activeClass}" type="button" data-id="${post.id}">
          <span class="post-item-title">${escapeHtml(post.title)}</span>
          <span class="post-item-meta">${escapeHtml(post.author)} · ${escapeHtml(post.created_at)}</span>
        </button>
      `;
    })
    .join("");
}

function resetDetail() {
  selectedPostId = null;
  detail.hidden = true;
  detailEmpty.hidden = false;
  detailState.textContent = "선택 대기";
  detailTitle.textContent = "";
  detailMeta.textContent = "";
  detailContent.textContent = "";
}

function renderDetail(post) {
  selectedPostId = post.id;
  detail.hidden = false;
  detailEmpty.hidden = true;
  detailState.textContent = `#${post.id}`;
  detailTitle.textContent = post.title;
  detailMeta.textContent = `${post.author} · ${post.created_at}`;
  detailContent.textContent = post.content;

  document.querySelectorAll(".post-item").forEach((item) => {
    item.classList.toggle("active", Number(item.dataset.id) === post.id);
  });
}

async function loadPosts() {
  try {
    const posts = await requestJson("/api/posts");
    renderList(posts);
  } catch (error) {
    showMessage(error.message, true);
  }
}

async function loadPost(postId) {
  try {
    const post = await requestJson(`/api/posts/${postId}`);
    renderDetail(post);
  } catch (error) {
    showMessage(error.message, true);
  }
}

async function createPost(event) {
  event.preventDefault();

  const payload = {
    title: form.title.value.trim(),
    author: form.author.value.trim(),
    content: form.content.value.trim(),
  };

  if (!payload.title || !payload.author || !payload.content) {
    showMessage("제목, 작성자, 내용을 모두 입력하세요.", true);
    return;
  }

  try {
    const post = await requestJson("/api/posts", {
      method: "POST",
      body: JSON.stringify(payload),
    });
    form.reset();
    showMessage("게시글을 등록했습니다.");
    await loadPosts();
    await loadPost(post.id);
  } catch (error) {
    showMessage(error.message, true);
  }
}

async function deleteSelectedPost() {
  if (!selectedPostId) {
    return;
  }

  const ok = window.confirm("선택한 게시글을 삭제할까요?");
  if (!ok) {
    return;
  }

  try {
    await requestJson(`/api/posts/${selectedPostId}`, { method: "DELETE" });
    showMessage("게시글을 삭제했습니다.");
    resetDetail();
    await loadPosts();
  } catch (error) {
    showMessage(error.message, true);
  }
}

function escapeHtml(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}

form.addEventListener("submit", createPost);
refreshButton.addEventListener("click", loadPosts);
deleteButton.addEventListener("click", deleteSelectedPost);

postList.addEventListener("click", (event) => {
  const item = event.target.closest(".post-item");
  if (!item) {
    return;
  }
  loadPost(Number(item.dataset.id));
});

resetDetail();
loadPosts();
