<%--

       Copyright 2010-2025 the original author or authors.

       Licensed under the Apache License, Version 2.0 (the "License");
       you may not use this file except in compliance with the License.
       You may obtain a copy of the License at

          https://www.apache.org/licenses/LICENSE-2.0

       Unless required by applicable law or agreed to in writing, software
       distributed under the License is distributed on an "AS IS" BASIS,
       WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
       See the License for the specific language governing permissions and
       limitations under the License.

--%>
<%@ include file="../common/IncludeTop.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- ★★★ 1. 비교하기 버튼 (우측 상단 고정) ★★★ -->
<button class="compare-btn-fixed" id="compareBtn" onclick="openComparisonPopup()" disabled>
    Compare
</button>

<jsp:useBean id="catalog"
             class="org.mybatis.jpetstore.web.actions.CatalogActionBean" />

<div id="BackLink">
    <%-- ★★★ 2. [복구] "ALL" 카테고리일 때 메인 메뉴로 돌아가는 로직 ★★★ --%>
    <c:choose>
        <c:when test="${actionBean.product.categoryId == 'ALL'}">
            <stripes:link beanclass="org.mybatis.jpetstore.web.actions.CatalogActionBean">
                Return to Main Menu
            </stripes:link>
        </c:when>
        <c:otherwise>
            <stripes:link beanclass="org.mybatis.jpetstore.web.actions.CatalogActionBean" event="viewCategory">
                <stripes:param name="categoryId" value="${actionBean.product.categoryId}" />
                Return to ${actionBean.product.categoryId}
            </stripes:link>
        </c:otherwise>
    </c:choose>
</div>

<div id="Catalog">

    <h2>${actionBean.product.name}</h2>

    <table class="itemList">
        <tr>
            <th>Item ID</th>
            <th>Product ID</th>
            <th>Description</th>
            <th>List Price</th>
            <th>&nbsp;</th>
        </tr>
        <c:forEach var="item" items="${actionBean.itemList}">
            <tr>
                <td>
                        <%-- 팝업 링크 구조 --%>
                    <stripes:link
                            beanclass="org.mybatis.jpetstore.web.actions.CatalogActionBean"
                            event="viewItem"
                            class="item-link">
                        <stripes:param name="itemId" value="${item.itemId}" />
                        ${item.itemId}

                        <%-- 이미지 팝업 --%>
                        <div class="image-popup">
                            <img src="/jpetstore/images/placeholder.gif" alt="Item Image" />
                            <div class="recommend-text">
                                <c:choose>
                                    <c:when test="${not empty actionBean.productRecommendationMessage}">
                                        <div class="ai-copy ${actionBean.productRecommendationMessage.recommended ? 'RECOMMEND' : 'NOT_RECOMMEND'}">
                                            <div class="ai-copy-body">
                                                ${actionBean.productRecommendationMessage.message}
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:if test="${sessionScope.accountBean.authenticated}">
                                            <div class="ai-copy neutral">
                                                설문 답변을 반영한 추천 문구를 준비하는 중입니다.
                                            </div>
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <%-- 데이터 숨김 (이미지 경로용) --%>
                        <span class="popup-data" style="display: none;" data-id="${item.itemId}">
                             <c:out value="${item.product.description}" escapeXml="false" />
                        </span>
                    </stripes:link>
                </td>
                <td>${item.product.productId}</td>
                <td>${item.attribute1} ${item.attribute2} ${item.attribute3}
                        ${item.attribute4} ${item.attribute5} ${actionBean.product.name}</td>
                <td><fmt:formatNumber value="${item.listPrice}"
                                      pattern="$#,##0.00" /></td>
                <td><stripes:link class="Button"
                                  beanclass="org.mybatis.jpetstore.web.actions.CartActionBean"
                                  event="addItemToCart">
                    <stripes:param name="workingItemId" value="${item.itemId}" />
                    Add to Cart
                </stripes:link></td>
            </tr>
        </c:forEach>
        <%-- ★★★ 3. [삭제됨] 여기에 있던 빈 <tr> 태그를 제거했습니다. (이상한 체크박스 원인) ★★★ --%>
    </table>

</div>

<script>
    // 이미지 경로 추출 함수
    function extractImagePath(desc) {
        if (!desc) return '/jpetstore/images/placeholder.gif';
        const match = desc.match(/<img src="([^"]+)">/);
        if (match && match[1]) {
            return match[1].replace('../', '/jpetstore/');
        }
        return '/jpetstore/images/placeholder.gif';
    }

    document.addEventListener('DOMContentLoaded', function() {
        const links = document.querySelectorAll('.item-link');

        links.forEach(link => {
            const popup = link.querySelector('.image-popup');
            const dataSpan = link.querySelector('.popup-data');
            const imgTag = popup ? popup.querySelector('img') : null;

            if (popup && dataSpan && imgTag) {
                // 이미지 설정
                const description = dataSpan.innerHTML;
                imgTag.src = extractImagePath(description);
            }

            // 마우스 오버 이벤트
            if (link && popup) {
                link.addEventListener('mouseenter', function() {
                    popup.style.display = 'block';
                });
                link.addEventListener('mouseleave', function() {
                    popup.style.display = 'none';
                });
            }
        });
    });
</script>

<%@ include file="../common/IncludeBottom.jsp"%>